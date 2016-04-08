module ApplicationHelper
  MARKS = {
    previous: "&#8592; ".html_safe,
    next: " &#8594;".html_safe
  }

  DEFAULT_TITLE = "Tsukasa OISHI"

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
end
