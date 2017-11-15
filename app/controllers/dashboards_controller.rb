class DashboardsController < ApplicationController
  def index
    @articles = Article.recent_articles(10)
  end
end
