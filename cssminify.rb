class CSS
	def initialize(file)
		@file_name = file
		@file_name_min = file.clone.gsub(/(.css)/, "")
		clean_file
	end	

	def clean_file
		@mincss = File.open("#{@file_name_min}.min.css", "w")
		File.open(@file_name, "r") do |line|
			line.each_line { |f| @mincss.puts(f.gsub(/\s+/, ""))}
		end
	end
end
# Edit 'style.css' to your CSS file name.
CSS::new('style.css')
