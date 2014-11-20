class AboutController < ApplicationController
  def index
    @articles = current_user.recent_articles(7)
  end
end
