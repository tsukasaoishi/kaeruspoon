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
        when "a", "d"
          article_link(type, data)
        when "p"
          photo_link(data.to_i)
        when /^\[/
          part
        else
          content_tag(:span, part, class: "accent")
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
      link_to(title.presence || url, url, target: "_blank")
    end

    def article_link(type, data)
      if data =~ /^(\d{4})(\d{2})(\d{2})$/
        year, month, day = $1, $2, $3
        link_to(
          "#{year}年#{month}月#{day}日の日記",
          date_articles_path(year: year, month: month, day: day)
        )
      else
        article = Article.find_by_id(data.to_i)
        article ? link_to(article.title, article_path(article)) : ""
      end
    end

    def photo_link(photo_id)
      if photo = Photo.find_by_id(photo_id)
        link_to(
          image_tag(photo.image.url(:large)),
          photo.image.url(:original),
          target: "_blank",
          class:  "article_image"
        )
      else
        ""
      end
    end
  end
end
