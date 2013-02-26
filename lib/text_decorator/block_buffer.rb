class TextDecorator
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
        when /^\[/
          part
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
end
