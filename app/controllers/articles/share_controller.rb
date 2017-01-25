class Articles::ShareController < ApplicationController
  def index
    @articles = Article.recent_articles(30).joins(:share_to_sns).includes(:content)
  end
end
