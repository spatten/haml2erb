module Haml2Erb
  class ErbWriter

    def initialize
      @processed = ''
      @tag_stack = [ ]
    end

    def <<(line_options)

      else_block = (line_options[:content_type] == :ruby_run and (line_options[:contents] =~ /^\s*else\s*$/ or line_options[:contents] =~ /^\s*elsif\s/))
      ruby_block = (line_options[:content_type] == :ruby_run and (line_options[:contents] =~ / do(\s*\|[\w\d_,\s]+\|)?$/ or line_options[:contents] =~ /^\s*if / or else_block))
      close_tags(line_options[:indent], :incoming_else_block => else_block)
      @tag_stack.push(line_options[:element_type]) if line_options[:element_type] and !line_options[:self_closing_tag]
      @tag_stack.push(:ruby_block) if ruby_block

      @processed << ("  " * line_options[:indent]) if line_options[:indent]
      @processed << "<#{line_options[:element_type].to_s}" if line_options[:element_type]
      @processed << " id=\"#{line_options[:element_id].to_s}\"" if line_options[:element_id]
      @processed << " class=\"#{[*line_options[:element_class]].join(' ')}\"" if line_options[:element_class]
      line_options[:element_attributes] && line_options[:element_attributes].keys.each do |attribute_key|
        @processed << " #{attribute_key}=\"#{line_options[:element_attributes][attribute_key]}\""
      end
      @processed << " /" if line_options[:self_closing_tag]
      @processed << ">" if line_options[:element_type]

      case(line_options[:content_type])
      when :text
        @processed << (line_options[:contents] || "")
      when :ruby
        @processed << ("<%= " + line_options[:contents] + " %>")
      when :ruby_run
        @processed << ("<% " + line_options[:contents] + " %>")
      when :mixed
        @processed << ('<%= "' + line_options[:contents] + '" %>')
      end

      close_tags(line_options[:indent], :separate_line => false) if line_options[:contents] and !line_options[:self_closing_tag] and !ruby_block
      @processed << "\n"
    end

    def output_to_string
      close_tags(0)
      @processed
    end

    private

    def close_tags(current_indent, options = {})
      options = { :separate_line => true }.merge(options)
      while(@tag_stack.size > current_indent)
        indent = @tag_stack.size - 1
        stack_item = @tag_stack.pop
        if stack_item == :ruby_block
          unless options[:incoming_else_block]
            @processed << ("  " * (indent)) if options[:separate_line] == true
            @processed << "<% end %>"
            @processed << "\n" if options[:separate_line] == true
          end
        else
          @processed << ("  " * (indent)) if options[:separate_line] == true
          @processed << "</#{stack_item.to_s}>"
          @processed << "\n" if options[:separate_line] == true
        end
      end
    end
  end
end