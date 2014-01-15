require 'mincss/version'

module Mincss
  class CSS
  	def initialize(file)
  		@file_name = file
  		@file_name_min = file.clone.gsub(/(.css)/, "")
  		clean_file
  	end	

  	def clean_file
  		@mincss = File.open("#{@file_name_min}.min.css", "w")
  		File.open(@file_name, "r") do |file|
  			file.each_line do |line|
  				line.each_line do |part|
            @mincss.print part
            @mincss.print " " if part[/\w/]
          end
  			end
  		end
  	end 
  end

  # Edit 'style.css' to your CSS file name.
  CSS::new('style.css')
  
  # This code doesn't belong here. Move to separate file in the future.
end
