class TextDecorator

  class << self
    include ActionView::Helpers::TagHelper
    def interpret_notation(text)
      text.gsub(/\r\n/, "\n").gsub(/\r/, "\n").split(/\n{2,}/).map do |line|
        content_tag(:p, line.gsub(/\n/, tag(:br)).html_safe)
      end.join
    end
  end
end
