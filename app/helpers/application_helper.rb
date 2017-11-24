module ApplicationHelper
  MARKS = {
    previous: "&#8592; ".html_safe,
    next: " &#8594;".html_safe
  }
  private_constant :MARKS

  DEFAULT_TITLE = "kaeruspoon"
  private_constant :DEFAULT_TITLE

  AVATAR_IMAGE = {
    url: "https://www.gravatar.com/avatar/76de73a1dae79a86bb99a813bd8e8e0a",
    params: "d=http%3A%2F%2Fkaeruspoon%.net2F2014%2Fimages%2Fno-image.png"
  }
  private_constant :AVATAR_IMAGE

  def previous_link_to(name, url, options = {})
    name = MARKS[:previous] + h(name)
    link_to(name, url, options)
  end

  def next_link_to(name, url, options = {})
    name = h(name) + MARKS[:next]
    link_to(name, url, options)
  end

  def title_name
    if defined?(@title)
      @title
    else
      DEFAULT_TITLE
    end
  end

  def avatar_icon_tag(size = 20)
    url = [AVATAR_IMAGE[:url], "?s=#{size}&", AVATAR_IMAGE[:params]].join
    image_tag url
  end
end
