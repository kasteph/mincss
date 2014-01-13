class CSS

	def initialize(file_name)
		@file_name = file_name
	end	

	def open_file
		@css = File.open(@file_name, "r+").each_line do |line|
			minify(line)
		end
	end

	def minify(line)
		minified = line.gsub(/\s+/, "")
	end
end

# Edit 'style.css' to your CSS file name.
stylesheet = CSS.new('style.css')