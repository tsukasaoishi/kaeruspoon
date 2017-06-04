class Articles::PopularController < ApplicationController
  caches_action :index, expires_in: 1.minute

  def index
    @articles = Article.popular_articles(30)
    @title = I18n.t(:popular_articles)
    @sub_title = @title
  end
end
