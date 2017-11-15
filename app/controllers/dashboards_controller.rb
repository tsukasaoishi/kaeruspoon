class DashboardsController < ApplicationController
  def index
    @articles = Article.recent_articles(30)
  end
end
