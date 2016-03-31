module ArticleDecorator
  def linked_publish_at
    [
      publish_at.strftime("%A,"),
      link_to(publish_at.strftime("%b"), articles_date_path(to_date_hash)),
      publish_at.strftime("%d, %Y")
    ].join(' ').html_safe
  end
end
