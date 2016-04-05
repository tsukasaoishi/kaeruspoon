class Articles::PopularController < ApplicationController
  caches_action :index, expires_in: 1.week

  def index
    @articles = Article.popular_articles(30)
    @sub_title = I18n.t(:popular_articles)
  end
end
