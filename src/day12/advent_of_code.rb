
class Garden
	def initialize(file_path)
		file_content = File.read(file_path)
		lines = file_content.split("\n")

		@height = lines.length
		@width = lines.first.length
		@plots = lines.join
	end

	def to_string
		"Width: #{@width}, Height: #{@width}."
	end
end

garden = Garden.new("input.sample.txt")
puts garden.to_string
