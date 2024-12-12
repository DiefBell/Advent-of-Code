require 'set'

class Coord
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    other.is_a?(Coord) && self.x == other.x && self.y == other.y
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

    # Print to_s of each region in @regions
    @regions.each do |region|
      puts region.to_s
    end
  end

  def to_s
    total_cost = @regions.sum { |region| region.get_cost }
    "Width: #{@width}, " +
    "Height: #{@height}. " +
    "Unique regions: #{@regions.length}. " +
    "Total cost: #{total_cost}"
  end
end

class Plot
  attr_accessor :letter, :region, :coord

  def initialize(letter, coord)
    @letter = letter
    @coord = coord

    fences = [
      Coord.new(coord.x, coord.y),
      Coord.new(coord.x, coord.y + 1),
      Coord.new(coord.x + 1, coord.y),
      Coord.new(coord.x + 1, coord.y + 1)
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

    # Merge fences by merging only unique ones, then removing "shared" fences
    fences_to_remove = (other.fences & @fences)
    @fences |= other.fences  # Union of fences

    # Remove shared fences from both regions
    @fences -= fences_to_remove

    # Return self to allow chaining
    self
  end

  def get_area
    @plots.length
  end

  def get_cost
    get_area * @fences.length
  end

  def to_s
    "Region with letter '#{@letter}' has #{@plots.length} plots and #{@fences.length} fences."
  end
end

puts "\n"
garden = Garden.new("input.sample.txt")
puts garden.to_s
