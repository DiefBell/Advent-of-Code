class Garden
	def initialize(file_path)
		file_content = File.read(file_path)
		lines = file_content.split("\n")
		@height = lines.length
		@width = lines.first.length

		@plots = lines.map do |row|
			row.chars.map { |char| Plot.new(char) }
		end
	end

	def to_s
		"Width: #{@width}, Height: #{@width}."
	end
end

class Plot
	def initialize(letter)
		@letter = letter;
		@region = nil;
	end
end

class Region
	def initialize(plots, fences)
		@plots = plots
		@area = plots.length
		@fences = fences
	end

	def self.merge(a, b)
		return Region.new(a + b)
	end

	def get_cost()
		return @area * @fences
	end
end

garden = Garden.new("input.sample.txt")
puts garden.to_s
