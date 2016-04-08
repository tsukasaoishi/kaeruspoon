class Articles::DateController < ApplicationController
  caches_action :index, expires_in: 1.month

  def index
    y, m, d = params.values_at(:year, :month, :day)
    date_range = d ? :day : :month
    start = Time.zone.local(y, m, d || 1)
    @articles = Article.period_articles(start, date_range)
    if @articles.present?
      @prev_article = @articles.first.prev_article
      @next_article = @articles.last.next_article
    end

    @title = I18n.l(start, format: date_range) + I18n.t(:articles)
    @sub_title = @title
  end
end
