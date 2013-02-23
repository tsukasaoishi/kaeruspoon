class TextDecorator
  #
  # build <pre> tag
  #
  class PreBuffer < Array
    REGEXP_PRE_BEGIN = /^>\|\|$/
    REGEXP_PRE_END = /^\|\|<$/

    def begin?(str)
      @on = (str =~ REGEXP_PRE_BEGIN)
    end

    def finish?(str)
      str =~ REGEXP_PRE_END
    end

    def on?
      !!@on
    end

    def flash
      return "" if empty?

      CodeRay.scan(join("\n"), :ruby).div
    ensure
      @on = false
      clear
    end
  end

  #
  # build <p> tag
  #
  class BlockBuffer < Array
    include ActionView::Helpers::TagHelper
    include Rails.application.routes.url_helpers

    # not use. accessing while testing...
    # TODO: after fix
    attr_reader :controller

    def push(str)
      super if str.present?
    end

    def flash
      return "" if empty?

      inner = join(tag(:br)).gsub(/\[(.+?)\]/) do
        part = $1
        type, data, option = part.split(":")
        case type
        when /^https?$/
          http_link(type, data, option)
        when "a"
          article_link(data.to_i)
        else
          content_tag(:span, part, :class => "accent")
        end
      end

      content_tag(:p, inner.html_safe)
    ensure
      clear
    end

    private

    def http_link(type, data, option)
      url = "#{type}:#{data}"
      title = option.scan(/^title=(.+?)$/).flatten.first if option
      link_to(title.presence || url, url, :target => "_blank")
    end

    def article_link(article_id)
      article = Article.find_by_id(article_id)
      article ? link_to(article.title, article_path(article)) : ""
    end
  end

  class << self
    def interpret_notation(text)
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
