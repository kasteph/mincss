require './mincss/version'
require_relative "./mincss/base"

module Mincss
  class Minimizer
    
    SELECTOR_OPENING  = "}"
    SELECTOR_CLOSING  = "{"
    SELECTOR_COMMA    = ","
    PROPERTY_OPENING  = ":"
    PROPERTY_CLOSING  = ";"
    
  	def initialize(filename)
  		@filename = filename
  		@filename_min = filename.clone.gsub(/(.css)/, "")
      @inside_property = false
      @inside_selector = false
  		clean_file
  	end	

  	def clean_file
  		content = File.read(@filename)          
      formatted = strip_tabs(content)
      formatted = strip_newlines(formatted)      
      formatted = process_whitespace(formatted)
      
      write_file(formatted)
  	end 
    
    def write_file(content)  
      File.open("#{@filename_min}.min.css", "w") do |file|
        file.write(content)
      end
    end
    
    def strip_tabs(content)
      content.gsub!("\t",  "")
    end
        
    def strip_newlines(content)
      content.gsub!("\n", "")
    end
    
    def preserve_whitespace(content, char)
      if property_opening?(char)
        @inside_property = true
      elsif property_closing?(char)          
        if content[-1] == " "
          content[-1] = ""
        end          
        @inside_property = false
      end
      
      if selector_opening?(char)
        @inside_selector = true
      elsif selector_closing?(char)
        if content[-1] == " "
          content[-1] = ""
        end
        @inside_selector = false
      end
      
      content
    end
    
    def strip_whitespace(formatted, char, last_char)      
      if whitespace?(char)          
        if @inside_property            
          if last_char == PROPERTY_OPENING
            formatted << ""
          else
            formatted << char
          end
        elsif @inside_selector
          if last_char == SELECTOR_CLOSING || last_char == SELECTOR_COMMA
            formatted << ""
          else
            formatted << char
          end
        end
      else        
        formatted << char
      end
      
      formatted
    end
    
    def process_whitespace(content)
      formatted = ""
      char = ""
      last_char = ""      
      
      # reduce all spaces to one space for initial processing.
      content.gsub!(/\s+/, " ")      
            
      content.each_char do |char|       
        formatted = preserve_whitespace(formatted, char)
        formatted = strip_whitespace(formatted, char, last_char)              
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
      char == PROPERTY_OPENING && !@inside_selector
    end
    
    def property_closing?(char)
      char == PROPERTY_CLOSING && !@inside_selector
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
