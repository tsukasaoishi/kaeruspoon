Dir.glob(File.join(__dir__, "text_decorator/*")).each do |file|
  require file
end

class TextDecorator
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  class << self
    def replace(text)
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
