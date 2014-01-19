require './mincss/version'
require_relative "./mincss/base"

module Mincss
  class Minimizer
    
    SELECTOR_OPENING = "}"
    SELECTOR_CLOSING = "{"
    PROPERTY_OPENING = ":"
    PROPERTY_CLOSING = ";"
    
  	def initialize(filename)
  		@filename = filename
  		@filename_min = filename.clone.gsub(/(.css)/, '')
      @inside_property = false
      @inside_selector = false
  		clean_file
  	end	

  	def clean_file
  		content = File.read(@filename)          
      formatted = remove_tabs(content)
      formatted = remove_newlines(formatted)      
      # reduce all spaces to one space for initial processing.
      content.gsub!(/\s+/, ' ')      
      formatted = remove_whitespace(formatted)
      
      write_file(formatted)
  	end 
    
    def write_file(content)  
      File.open("#{@filename_min}.min.css", 'w') do |file|
        file.write(content)
      end
    end
    
    def remove_tabs(content)
      content.gsub!("\t", "")
    end
        
    def remove_newlines(content)
      content.gsub!("\n", "")
    end
    
    def remove_whitespace(content)
      formatted = ""
      char = ""
      last_char = ""
      
      content.each_char do |char|        
        if property_opening?(char)
          @inside_property = true
        elsif property_closing?(char)          
          if formatted[-1] == " "
            formatted[-1] = ""
          end          
          @inside_property = false
        end
        
        if selector_opening?(char)
          @inside_selector = true
        elsif selector_closing?(char)
          if formatted[-1] == " "
            formatted[-1] = ""
          end
          @inside_selector = false
        end
        
        if whitespace?(char)
          
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
        
        last_char = char
      end
           
      formatted
    end
    
    def selector_opening?(char)
      char == SELECTOR_OPENING && !@inside_property
    end
    
    def selector_closing?(char)
      char == SELECTOR_CLOSING && !@inside_property
    end
    
    def property_opening?(char)
      char == PROPERTY_OPENING
    end
    
    def property_closing?(char)
      char == PROPERTY_CLOSING
    end
    
    def newline?(char)
      char == "\n"
    end
    
    def whitespace?(char)
      char ==  " "
    end
    
    def tab?(char)
      char == "\t"
    end
  end

  # Edit 'style.css' to your CSS file name.
  filename = 'test_style.css'
  Minimizer::new(filename)

  # This code doesn't belong here. Move to separate file in the future.
end
