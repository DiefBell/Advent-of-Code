require 'set'
require 'text-table'

# Represents a coordinate on a 2D plane.
class Coord
  attr_accessor :x, :y

  # Initializes a coordinate object.
  #
  # @param x [Integer] The x-coordinate
  # @param y [Integer] The y-coordinate
  def initialize(x, y)
    @x = x
    @y = y
  end

  # Checks equality of two coordinates.
  #
  # @param other [Coord] The other coordinate to compare
  # @return [Boolean] `true` if the coordinates are equal, `false` otherwise
  def ==(other)
    other.is_a?(Coord) && self.x == other.x && self.y == other.y
  end

  # Proper equality check for usage in sets.
  #
  # @param other [Coord] The other coordinate to compare
  # @return [Boolean] `true` if the coordinates are equal, `false` otherwise
  def eql?(other)
    other.is_a?(Coord) && @x == other.x && @y == other.y
  end

  # Generates a hash code for the coordinate.
  #
  # @return [Integer] A unique hash value for the coordinate
  def hash
    [@x, @y].hash
  end

  # Returns a string representation of the coordinate.
  #
  # @return [String] The coordinate in "(x, y)" format
  def to_s
    "(#{x}, #{y})"
  end
end

# Represents a garden defined by plots and regions.
class Garden
  # Initializes the garden from a file.
  #
  # @param file_path [String] Path to the input file describing the garden layout
  def initialize(file_path)
    file_content = File.read(file_path)
    lines = file_content.split("\n")
    @height = lines.length
    @width = lines.first.length
    @regions = Set.new

    # Create plots and regions
    @plots = lines.each_with_index.map do |row, row_index|
      row.chars.each_with_index.map do |char, col_index|
        coord = Coord.new(col_index, row_index)
        plot = Plot.new(char, coord)
        @regions.add(plot.region) # Add the Plot's region to regions
        plot
      end
    end

    merge_adjacent_regions
    create_table_data
  end

  # Returns a summary string of the garden's dimensions and costs.
  #
  # @return [String] The garden's summary
  def to_s
    total_price = @regions.sum { |region| region.get_price }
    total_discounted_price = @regions.sum { |region| region.get_discounted_price }
    "\nWidth: #{@width}, " \
    "Height: #{@height}. " \
    "Unique regions: #{@regions.length}. " \
    "Total cost: #{total_price}, " \
    "Discounted price: #{total_discounted_price}"
  end

  private

  # Merges adjacent regions based on plot letters.
  def merge_adjacent_regions
    # Merge regions horizontally
    (0...@height).each do |row_index|
      (0...(@width - 1)).each do |col_index|
        merge_if_same_letter(@plots[row_index][col_index], @plots[row_index][col_index + 1])
      end
    end

    # Merge regions vertically
    (0...@width).each do |col_index|
      (0...(@height - 1)).each do |row_index|
        merge_if_same_letter(@plots[row_index][col_index], @plots[row_index + 1][col_index])
      end
    end
  end

  # Merges two plots' regions if their letters match.
  #
  # @param plot1 [Plot] The first plot
  # @param plot2 [Plot] The second plot
  def merge_if_same_letter(plot1, plot2)
    return unless plot1.letter == plot2.letter && plot1.region != plot2.region

    region = plot1.region
    @regions.delete(plot1.region)
    @regions.delete(plot2.region)
    region.absorb(plot2.region)
    @regions.add(region)
  end

  # Creates table data for displaying region details.
  def create_table_data
    table_data = @regions.map(&:get_table_data)
    table = Text::Table.new
    table.head = ['Letter', 'Plots', 'Fences', 'Sides', 'Price', 'Discounted']
    table.rows = table_data
    puts table
  end
end

# Represents a single plot in the garden.
class Plot
  attr_accessor :letter, :region, :coord

  # Initializes a plot with a letter, coordinate, and fences.
  #
  # @param letter [String] The plot's identifying letter
  # @param coord [Coord] The plot's coordinate
  def initialize(letter, coord)
    @letter = letter
    @coord = coord
    fences = [
      Coord.new(coord.x - 0.5, coord.y),
      Coord.new(coord.x + 0.5, coord.y),
      Coord.new(coord.x, coord.y + 0.5),
      Coord.new(coord.x, coord.y - 0.5)
    ]
    @region = Region.new(letter, [self], fences)
  end

  # Returns a string representation of the plot.
  #
  # @return [String] Description of the plot
  def to_s
    "Plot has letter '#{@letter}' and coord #{@coord}"
  end
end

# Represents a region in the garden composed of plots and fences.
class Region
  attr_accessor :fences, :plots

  # Initializes a region.
  #
  # @param letter [String] The region's identifying letter
  # @param plots [Array<Plot>] The plots in the region
  # @param fences [Array<Coord>] The fences around the region
  def initialize(letter, plots, fences)
    @letter = letter
    @plots = Set.new(plots)
    @fences = Set.new(fences)
  end

  # Absorbs another region into this one.
  #
  # @param other [Region] The region to absorb
  # @return [Region] The updated region
  def absorb(other)
    other.plots.each { |plot| plot.region = self }
    @plots |= other.plots
    @fences ^= other.fences
    self
  end

  # Sorts vertical fences.
  #
  # @return [Array<Coord>] The sorted vertical fences
  def sort_vertical_fences
    vertical_fences = @fences.select { |f| f.x != f.x.to_i }
    sorted = vertical_fences.group_by(&:x)
      .sort_by(&:first)
      .flat_map { |_, fences| fences.sort_by(&:y) }
    sorted
  end

  # Sorts horizontal fences.
  #
  # @return [Array<Coord>] The sorted horizontal fences
  def sort_horizontal_fences
    horizontal_fences = @fences.select { |f| f.y != f.y.to_i }
    sorted = horizontal_fences.group_by(&:y)
      .sort_by(&:first)
      .flat_map { |_, fences| fences.sort_by(&:x) }
	sorted
  end

  # Calculates the total number of sides for the region.
  #
  # @return [Integer] Total sides of the region
  def get_sides
    vertical_fences = sort_vertical_fences
    horizontal_fences = sort_horizontal_fences
    
	  vertical_sides = 1;
    (1...vertical_fences.length).each do |i|
      fence = vertical_fences[i]
	    prev = vertical_fences[i-1] # There must always be at least two vertical fences

      if(fence.x != prev.x)
        # not even same vertical line
        vertical_sides += 1
      elsif (fence.y - prev.y > 1)
        # break in the fence -> means it's turned
        vertical_sides += 1
      end
    end
    
	horizontal_sides = 1
    # Where there is a plus-shaped intersection, another two sides result
    intersection_sides = 0
    (1...horizontal_fences.length).each do |i|
      fence = horizontal_fences[i]
	    prev = horizontal_fences[i-1] # There must always be at least two vertical fences

      if(fence.y != prev.y)
        # not even same vertical line
        horizontal_sides += 1
      elsif (fence.x - prev.x > 1)
        # break in the fence -> means it's turned
        horizontal_sides += 1
      elsif (
		@fences.any? { |f| f.x == fence.x - 0.5 && f.y == fence.y + 0.5 } &&
		@fences.any? { |f| f.x == fence.x - 0.5 && f.y == fence.y - 0.5 }
      )
        ## intersection
        intersection_sides += 2
      end
    end

	vertical_sides + horizontal_sides + intersection_sides
  end

  # Calculates the price of the region.
  #
  # @return [Integer] The usual price
  def get_price
    get_area * @fences.size
  end

  # Calculates the discounted price of the region.
  #
  # @return [Integer] The discounted price
  def get_discounted_price
    get_area * get_sides
  end

  # Returns the area of the region.
  #
  # @return [Integer] The number of plots
  def get_area
    @plots.size
  end

  # Returns the region's data for the table.
  #
  # @return [Array] Table data of the region
  def get_table_data
    [@letter, get_area, @fences.size, get_sides, get_price, get_discounted_price]
  end

  # Returns a string representation of the region.
  #
  # @return [String] Description of the region
  def to_s
    "[Region] Letter '#{@letter}', " \
    "Plots: #{@plots.size}, " \
    "Fences: #{@fences.size}, " \
    "Sides: #{get_sides}, " \
    "Usual price: #{get_price}, " \
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
