class TextDecorator
  #
  # build <p> tag
  #
  class BlockBuffer < Array
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::AssetTagHelper
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
          photo_link(data.to_i, option)
        when "amazon"
          amazon_link(data, option)
        when "youtube"
          youtube_link(data)
        when "nico"
          niconico_link(data)
        when "slideshare"
          slideshare_link(data)
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
        if article = Article.find_by_id(data.to_i)
          link_to(article.title, article_path(article))
        else
          content_tag(:scan, "[NotFound:a:#{data}]", style: "font-size:4em")
        end
      end
    end

    def photo_link(photo_id, size)
      Rails.logger.info size
      if photo = Photo.find_by_id(photo_id)
        size ||= :large
        image_tag(
          photo.image.url(size),
          class:  "article_image",
          itemprop: "image"
        )
      else
        content_tag(:scan, "[NotFound:p:#{photo_id}]", style: "font-size:4em")
      end
    end

    def amazon_link(data, option)
      if a = AmazonStock.find_by_asin(data)
        case option
        when "image"
          amazon_image(a)
        when "detail"
          inner_detail = []
          inner_detail << content_tag(:div, amazon_image(a), class: "amazon_image")
          infos = []
          infos << link_to(a.product_name, a.url)
          infos << a.creator if a.creator.present?
          infos << a.manufacturer if a.manufacturer.present?
          infos << a.media if a.media.present?
          infos << a.release_date if a.release_date.present?
          inner_detail << content_tag(:div, infos.join("<br>").html_safe, class: "amazon_info")
          inner_detail << content_tag(:div, "", class: "amazon_clear")
          content_tag(:div, inner_detail.join.html_safe, class: "amazon_box")
        else
          link_to("「#{a.product_name}」", a.url)
        end
      else
        content_tag(:scan, "[NotFound:amazon:#{data}]", style: "font-size:4em")
      end
    end

    def amazon_image(amazon)
      link_to(
        image_tag(
          amazon.medium_image_url,
          width: amazon.medium_image_width,
          height: amazon.medium_image_height,
          title: amazon.product_name,
          alt: amazon.product_name
        ),
        amazon.url
      )
    end

    def youtube_link(youtube_id)
      %Q|<div class="video-container"><iframe width="640" height="480" src="http://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe></div>|
    end

    def niconico_link(nico_id)
      %Q|<script type="text/javascript" src="http://ext.nicovideo.jp/thumb_watch/sm#{nico_id}?w=490&h=307"></script><noscript><a href="http://www.nicovideo.jp/watch/sm#{nico_id}">【ニコニコ動画】</a></noscript>|
    end

    def slideshare_link(slideshare_id)
      %Q|<iframe src="http://www.slideshare.net/slideshow/embed_code/#{slideshare_id}" width="427" height="356" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>|
    end
  end
end
