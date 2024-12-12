require 'set'

class Coord
  attr_accessor :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
  end

  # Overloading the == method to compare Coords by their coordinates
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
    @regions = Set.new  # Use Set to store unique regions

    # Create @plots and @regions
    @plots = lines.each_with_index.map do |row, row_index|
      row.chars.each_with_index.map do |char, col_index|
        coord = Coord.new(col_index, row_index)  # Create a Coord based on row/col position
        plot = Plot.new(char, coord)  # Pass Coord to Plot constructor
        @regions.add(plot.region)  # Add the Plot's region to @regions
        plot  # Return the Plot object
      end
    end

    # Merge regions row-by-row
    @plots.each_with_index do |row, row_index|
      row.each_with_index do |plot, col_index|
        next_plot = row[col_index + 1] if col_index + 1 < row.length  # Get the next plot in the row

        if next_plot && plot.letter == next_plot.letter && plot.region != next_plot.region
          merged_region = plot.region + next_plot.region

          # Remove old regions from @regions
          @regions.delete(plot.region)
          @regions.delete(next_plot.region)

          # Add the merged region to @regions
          @regions.add(merged_region)

          # Set the new region for both plots
          plot.region = merged_region
          next_plot.region = merged_region
        end
      end
    end

    # Merge regions column-by-column
    @plots.each_with_index do |row, row_index|
      row.each_with_index do |plot, col_index|
        next_plot = @plots[row_index + 1] && @plots[row_index + 1][col_index]  # Get the plot below in the same column

        if next_plot && plot.letter == next_plot.letter && plot.region != next_plot.region
          merged_region = plot.region + next_plot.region

          # Remove old regions from @regions
          @regions.delete(plot.region)
          @regions.delete(next_plot.region)

          # Add the merged region to @regions
          @regions.add(merged_region)

          # Set the new region for both plots
          plot.region = merged_region
          next_plot.region = merged_region
        end
      end
    end


    # Print to_s of each region in @regions
    @regions.each do |region|
      puts region.to_s
    end
  end

  def to_s
    total_cost = @regions.sum { |region| region.get_cost }  # Sum the cost of each region
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
end

class Region
  attr_accessor :fences, :plots

  def initialize(letter, plots, fences)
    @letter = letter
    @plots = plots
    @fences = fences
  end

  # Define the '+' operator to merge two regions
  def +(other)
    # Merge the plots and fences of the two regions
    merged_plots = @plots + other.plots
    # Merges arrays but removes any elements that appear in both
    # i.e. removes shared fences
    merged_fences = (@fences - other.fences) + (other.fences - @fences)

    # Return a new Region object with the merged plots and fences
    Region.new(@letter, merged_plots, merged_fences)
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

garden = Garden.new("input.sample.txt")
puts garden.to_s
