class EntranceController < ApplicationController
  def index
    @article = current_user.recent_articles(1).first
    @diary = current_user.recent_diaries(1).first
  end
end
