require 'mincss/version'

module Mincss
  class CSS
  	def initialize(file)
  		@file_name = file
  		@file_name_min = file.clone.gsub(/(.css)/, "")
  		min_generate
  	end	

  	def min_generate
  		@mincss = File.open("#{@file_name_min}.min.css", "w")
  		File.open(@file_name, "r") do |file|
  			file.each_line do |line|
          initial_clean
        end
  		end
  	end 
  
    def initial_clean
      line.each_line do |part|
          @mincss.print part
          @mincss.print " " if part[/\w/]
        end
      end
    end

  end

  begin
  # Edit 'style.css' to your CSS file name.
    filename = 'style.css'
    CSS::new(filename)
  rescue
    p "File not found."
  end
  
  # This code doesn't belong here. Move to separate file in the future.
end
