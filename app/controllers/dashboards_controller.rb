class DashboardsController < ApplicationController
  def index
    @articles = Article.recent_articles(5)
    @no_header = true
  end
end
