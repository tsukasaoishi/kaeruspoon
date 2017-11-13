class DashboardsController < ApplicationController
  def index
    @articles = Article.recent_articles(10)
    @no_header = true
  end
end
