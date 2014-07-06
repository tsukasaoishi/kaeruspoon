Dir.glob(File.join(__dir__, "text_decorator/*")).each do |file|
  require file
end
require 'redcarpet/compat'

class TextDecorator
  OPTIONS = %i(autolink no_intra_emphasis fenced_code_blocks disable_indented_code_blocks strikethrough tables lax_spacing space_after_headers superscript underline highlight quote footnotes hard_wrap)
  class << self
    def replace(text)
      html = Keyword.convert(Markdown.new(text, *OPTIONS).to_html)
      syntax_highlighter(html).html_safe
    end

    def syntax_highlighter(html)
      doc = Nokogiri::HTML(html)
      doc.search("pre").each do |pre|
        pre.replace(Pygments.highlight(
          pre.text.rstrip,
          lexer: pre.children.attribute("class").value
        ))
      end
      doc.to_s
    end

    def old_replace(text)
      output = ""
      pre_buffer = PreBuffer.new
      block_buffer = BlockBuffer.new

      text.gsub(/\r\n/, "\n").gsub(/\r/, "\n").split(/\n/).each do |line|
        if pre_buffer.on?
          if pre_buffer.finish?(line)
            output << pre_buffer.flash
          else
            pre_buffer << line
          end
        elsif pre_buffer.begin?(line)
          output << block_buffer.flash
        else
          if line.blank?
            output << block_buffer.flash
          else
            block_buffer << line
          end
        end
      end

      output << block_buffer.flash
      output.html_safe
    end
  end
end
