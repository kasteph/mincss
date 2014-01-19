require './mincss/version'
require_relative "./mincss/base"

module Mincss
  class Minimizer
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
      content
    end
    
    def remove_whitespace(content)
      formatted = ""
      char = ""
      last_char = ""
      
      for i in 0...content.length
        last_char = char
        char = content[i]
        
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
  filename = 'test_style.css'
  Minimizer::new(filename)

  # This code doesn't belong here. Move to separate file in the future.
end
