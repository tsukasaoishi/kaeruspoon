class DiariesController < ApplicationController
  caches_action :index, expires_in: 1.day, if: lambda{ !logged_in? }

  def index
    start = Time.local(params[:year], params[:month], 1)
    @articles = current_user.period_articles(start, :month).diary
    @title = I18n.l(start, format: :month) + "の日記"

    if @articles.present?
      @prev_article = @articles.first.prev_month_article
      @next_article = @articles.first.next_month_article
    end
  end

  def archive
    @calendar = Article.diary_calendar
    @title = I18n.t(:archive_diaries)
  end
end
