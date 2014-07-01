class DiariesController < ApplicationController
  def index
    start = Time.local(params[:year], params[:month], 1)
    @articles = current_user.period_articles(start, :month).diary

    @title = I18n.l(start, format: :month) + "の日記"
  end

  def archive
    @calendar = Article.diary_calendar
    @title = I18n.t(:archive_diaries)
  end
end
