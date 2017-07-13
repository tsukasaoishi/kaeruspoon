class Articles::PopularController < ApplicationController
  def index
    @articles = Article.popular_articles(30)
    @title = I18n.t(:popular_articles)
    @sub_title = @title
  end
end
