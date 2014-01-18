require './mincss/version'
require_relative "./mincss/base"

module Mincss
  class Minimizer
  	def initialize(file)
  		@file_name = file
  		@file_name_min = file.clone.gsub(/(.css)/, "")
      @inside_property = false
      @inside_selector = false
  		clean_file
  	end	

  	def clean_file
  		text = File.read(@file_name)    
      
      formatted = remove_tabs(text)
      formatted = remove_newlines(formatted)
      
      # reduce all spaces to one space for initial processing.
      text.gsub!(/\s+/, ' ')
      
      formatted = remove_whitespace(formatted)
      
      File.open("#{@file_name_min}.min.css", 'w') do |file|
        file.write(formatted)
      end
  	end 
    
    def remove_tabs(text)
      text.gsub!("\t", "")
    end
        
    def remove_newlines(text)
      text.gsub!("\n", "")
      text
    end
    
    def remove_whitespace(text)
      formatted = ""
      char = ""
      last_char = ""
      
      for i in 0...text.length
        last_char = char
        char = text[i]
        
        # ignore stripping whitespace to preserve shortcuts.
        if is_property_opening?(char)
          @inside_property = true
        elsif is_property_closing?(char)          
          if formatted[-1] == " "
            formatted[-1] = ""
          end          
          @inside_property = false
        end
        
        # ignore stripping whitespace to preserve descendents, etc.
        if is_selector_opening?(char)
          @inside_selector = true
        elsif is_selector_closing?(char)
          if formatted[-1] == " "
            formatted[-1] = ""
          end
          @inside_selector = false
        end
        
        if is_whitespace?(char)
          
          if @inside_property            
            if last_char == ':'
              formatted << ""
            else
              formatted << char
            end
          elsif @inside_selector
            if last_char == "{" || last_char == ","
              formatted << ""
            else
              formatted << char
            end
          end
        else        
          formatted << char
        end
      end
           
      formatted
    end
    
    def is_selector_opening?(char)
      char.include?("}") && !@inside_property
    end
    
    def is_selector_closing?(char)
      char.include?("{") && !@inside_property
    end
    
    def is_property_opening?(char)
      char.include? ":"
    end
    
    def is_property_closing?(char)
      char.include? ";"
    end
    
    def is_newline?(char)
      char.include? "\n"
    end
    
    def is_whitespace?(char)
      char.include? " "
    end
    
    def is_tab?(char)
      char.include? "\t"
    end
  end

  # Edit 'style.css' to your CSS file name.
  filename = 'style.css'
  Minimizer::new(filename)

  # This code doesn't belong here. Move to separate file in the future.
end
