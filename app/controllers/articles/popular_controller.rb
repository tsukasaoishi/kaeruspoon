class Articles::PopularController < ApplicationController
  caches_action :index, expires_in: 1.week

  def index
    @articles = Article.popular_articles(50)
    @title = I18n.t(:popular_articles)
  end
end
