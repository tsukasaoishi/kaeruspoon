require Rails.root.join("lib/text_decorator")

class Articles::PopularController < ApplicationController
  def index
    @articles = Article.popular_articles(50)
    @title = I18n.t(:popular_articles)
    @sub_title = @title
  end
end
