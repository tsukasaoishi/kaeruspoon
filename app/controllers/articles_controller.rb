class ArticlesController < ApplicationController
  def recent
    @articles = Article.includes(:content).order("publish_at DESC").limit(6)
    @no_turbolink = true
  end

  def show
    @article = Article.includes(:content).find(params[:id])
    @title = @article.title
  end

  def date
    y, m, d = params.values_at(:year, :month, :day)
    period_end_method = d ? :end_of_day : :end_of_month

    start = Time.local(y, m, d || 1)
    period = (start..(start.__send__(period_end_method)))

    @articles = Article.includes(:content).where(publish_at: period).order("publish_at")
  end
end
