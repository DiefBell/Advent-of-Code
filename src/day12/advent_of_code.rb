require 'set'
require 'text-table'

class Coord
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    other.is_a?(Coord) && self.x == other.x && self.y == other.y
  end

  # Proper equality check for sets
  def eql?(other)
    other.is_a?(Coord) && @x == other.x && @y == other.y
  end

  def hash
    [@x, @y].hash  # Use the tuple of x and y for the hash code
  end

  def to_s
    "(#{x}, #{y})"
  end
end

class Garden
  def initialize(file_path)
    file_content = File.read(file_path)
    lines = file_content.split("\n")
    @height = lines.length
    @width = lines.first.length
    @regions = Set.new

    # Create @plots and @regions
    @plots = lines.each_with_index.map do |row, row_index|
      row.chars.each_with_index.map do |char, col_index|
        coord = Coord.new(col_index, row_index)  
        plot = Plot.new(char, coord)  
        @regions.add(plot.region)  # Add the Plot's region to @regions
        plot  
      end
    end

    (0...@height).each do |row_index|
      (0...(@width - 1)).each do |col_index|
        plot = @plots[row_index][col_index]
        next_plot = @plots[row_index][col_index + 1]
    
        same_region = plot.region == next_plot.region
    
        if plot.letter == next_plot.letter && !same_region
          # Absorb next_plot.region into plot.region
          region = plot.region
    
          # Remove both regions from @regions before modifying
          @regions.delete(plot.region)
          @regions.delete(next_plot.region)
    
          # Absorb next_plot's region into plot's region
          region.absorb(next_plot.region)
    
          # Re-add the merged region
          @regions.add(region)
        end
      end
    end
    
    (0...@width).each do |col_index|
      (0...(@height - 1)).each do |row_index|
        plot = @plots[row_index][col_index]
        next_plot = @plots[row_index + 1][col_index]
    
        same_region = plot.region == next_plot.region
    
        if plot.letter == next_plot.letter && !same_region
          # Absorb next_plot.region into plot.region
          region = plot.region
    
          # Remove both regions from @regions before modifying
          @regions.delete(plot.region)
          @regions.delete(next_plot.region)
    
          # Absorb next_plot's region into plot's region
          region.absorb(next_plot.region)
    
          # Re-add the merged region
          @regions.add(region)
        end
      end
    end

    # Now create the table data for all regions
    table_data = @regions.map(&:get_table_data)

    # Set up the table with headers and data
    table = Text::Table.new
    table.head = [
      'Letter',
      'Plots',
      'Fences',
      'Sides',
      'Price',
      'Discounted'
    ]
    table.rows = table_data

    # Display the table
    puts table
  end

  def to_s
    total_price = @regions.sum { |region| region.get_price }
    total_discounted_price = @regions.sum { |region| region.get_discounted_price }
    "\nWidth: #{@width}, " +
    "Height: #{@height}. " +
    "Unique regions: #{@regions.length}. " +
    "Total cost: #{total_price}, " +
    "Discounted price: #{total_discounted_price}"
  end
end

class Plot
  attr_accessor :letter, :region, :coord

  def initialize(letter, coord)
    @letter = letter
    @coord = coord

    fences = [
      Coord.new(coord.x - 0.5, coord.y),
      Coord.new(coord.x + 0.5, coord.y ),
      Coord.new(coord.x, coord.y + 0.5),
      Coord.new(coord.x, coord.y - 0.5)
    ]

    @region = Region.new(letter, [self], fences)
  end

  def to_s
    "Plot has letter '#{@letter}' and coord #{@coord}"
  end
end

class Region
  attr_accessor :fences, :plots

  def initialize(letter, plots, fences)
    @letter = letter
    @plots = Set.new(plots)  # Use Set to ensure uniqueness
    @fences = Set.new(fences)  # Use Set to ensure uniqueness
  end

  # Absorbs "other" region into this one
  def absorb(other)
    # Update the region of the plots being absorbed
    other.plots.each do |plot|
      plot.region = self
    end
    
    # Merge the plots of the two regions (ensure uniqueness)
    @plots |= other.plots
  
    # Merge the fences but discard shared ones
    # (the symmetric difference)
    @fences = @fences ^ other.fences
  
    # Return self to allow chaining
    self
  end

  def get_area
    @plots.length
  end
end

class Region
  attr_accessor :fences, :plots

  def initialize(letter, plots, fences)
    @letter = letter
    @plots = Set.new(plots)  # Use Set to ensure uniqueness
    @fences = Set.new(fences)  # Use Set to ensure uniqueness
  end

  # Sort vertical fences (x coordinate off by 0.5)
  def sort_vertical_fences
    # Select only vertical fences (where x is off by 0.5)
    vertical_fences = @fences.select { |f| f.x != f.x.to_i }

    # Group by x coordinate and then sort by y coordinate within each group
    vertical_groups = vertical_fences.group_by { |f| f.x }

    # Sort the groups by x (outer sort), and within each group, sort by y (inner sort)
    vertical_groups.each do |x, fences|
      fences.sort_by! { |f| f.y }  # Sort fences within the group by y
    end

    # Now sort the groups by x coordinate
    sorted_vertical_fences = vertical_groups.sort_by { |x, _| x }.flat_map { |_, fences| fences }

    # Return the sorted list of fences
    sorted_vertical_fences
  end

  # Sort horizontal fences (y coordinate off by 0.5)
  def sort_horizontal_fences
    # Select only horizontal fences (where y is off by 0.5)
    horizontal_fences = @fences.select { |f| f.y != f.y.to_i }

    # Group by y coordinate and then sort by x coordinate within each group
    horizontal_groups = horizontal_fences.group_by { |f| f.y }

    # Sort the groups by y (outer sort), and within each group, sort by x (inner sort)
    horizontal_groups.each do |y, fences|
      fences.sort_by! { |f| f.x }  # Sort fences within the group by x
    end

    # Now sort the groups by y coordinate
    sorted_horizontal_fences = horizontal_groups.sort_by { |y, _| y }.flat_map { |_, fences| fences }

    # Return the sorted list of fences
    sorted_horizontal_fences
  end

  # Calculates the number of sides for this region
  def get_sides
    # Sort both vertical and horizontal fences
    vertical_fences = sort_vertical_fences
    horizontal_fences = sort_horizontal_fences

    vertical_sides = 1
    horizontal_sides = 1

    # Count vertical sides
    (1...vertical_fences.length).each do |i|
      fence = vertical_fences[i]
      prev = vertical_fences[i-1]

      if fence.x != prev.x
        # Fences aren't even in a line
        vertical_sides += 1
      elsif fence.y - prev.y > 1
        # They're not joined
        vertical_sides += 1
      end
    end

    # Count horizontal sides
    (1...horizontal_fences.length).each do |i|
      fence = horizontal_fences[i]
      prev = horizontal_fences[i-1]

      if fence.y != prev.y
        # Fences aren't even in a line
        horizontal_sides += 1
      elsif fence.x - prev.x > 1
        # They're not joined
        horizontal_sides += 1
      end
    end

    # The total number of sides is the sum of vertical and horizontal sides
    total_sides = vertical_sides + horizontal_sides
    total_sides
  end  
  
  def get_price
    get_area * @fences.length
  end

  def get_discounted_price
    get_area * get_sides
  end

  # Get table data for this region
  def get_table_data
    letter = @letter
    plot_number = @plots.length
    fences_number = @fences.length
    sides_number = get_sides
    usual_price = get_price
    discounted_price = get_discounted_price

    [letter, plot_number, fences_number, sides_number, usual_price, discounted_price]
  end

  def to_s
    "[Region] Letter '#{@letter}', " +
    "Plots: #{@plots.length}, " +
    "Fences: #{@fences.length}, " +
    "Sides: #{get_sides}, " +
    "Usual price: #{get_price}, " + 
    "Discounted price: #{get_discounted_price}"
  end
end

puts "\n"
# garden = Garden.new("input.sample.txt")
# garden = Garden.new("input.test.txt")
garden = Garden.new("input.txt")
puts garden.to_s

# 608664 is too low
# 814778 ain't right
