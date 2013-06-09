class ArticlesController < ApplicationController
  before_filter :required_login, only: [:new, :create, :edit, :update, :destroy]
  before_filter :access_count, only: :show

  caches_action :show, expires_in: 1.day, if: lambda{ !logged_in? }, cache_path: Proc.new{|c| c.params[:id]}
  caches_action :archive, expires_in: 1.day

  def index
    if request.format != :atom
      redirect_to root_path
    else
      @articles = Article.includes(:content).where("publish_at <= ?", Time.now).order("publish_at DESC").limit(20).to_a
    end
  end

  def recent
    article_conds = Article.includes(:content).order("publish_at DESC").limit(10)
    article_conds = article_conds.where("publish_at <= ?", Time.now) unless logged_in?
    @articles = article_conds.to_a

    @articles.first.top_rank!
    @articles[1..2].each{|a| a.middle_rank!}

    render "index"
  end

  def popular
    @articles = Article.includes(:content).order("access_count DESC").limit(100).to_a
    @articles.first.top_rank!
    @articles[1..2].each{|a| a.middle_rank!}

    @title = I18n.t(:popular_articles)
    render "index"
  end

  def date
    y, m, d = params.values_at(:year, :month, :day)
    period_end_method = d ? :end_of_day : :end_of_month
    start = Time.local(y, m, d || 1)
    finish = start.__send__(period_end_method)
    now = Time.now
    finish = now if finish > now
    period = (start..finish)

    @articles = Article.includes(:content).where(publish_at: period).order("publish_at").to_a
    Article.calc_rank(@articles)

    @title = I18n.l(start, format: (d ? :day : :month))
    render "index"
  end

  def archive
    @title = I18n.t(:archive_articles)
  end

  def show
    @title = @article.title
  end

  def new
    @article = Article.new(
      title: params[:backup_article_title],
      body: params[:backup_article_body],
      publish_at: Time.now
    )
  end

  def create
    article = Article.create!(require_params)
    Rails.cache.delete("views/#{article.prev_article.id}") if article.prev_article
    redirect_to article
  end

  def edit
    @article = Article.find(params[:id])
    if params.has_key?(:backup_article_title)
      @article.title = params[:backup_article_title]
      @article.body = params[:backup_article_body]
    end

    render "new"
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes!(require_params)
    Rails.cache.delete("views/#{article.id}")
    redirect_to article
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    redirect_to root_path
  end

  private

  def require_params
    params.require(:article).permit(:title, :body, :publish_at)
  end

  def access_count
    @article = Article.find(params[:id])
    raise ActiveRecord::RecordNotFound if !logged_in? && @article.publish_at > Time.now
    @article.count_up
  end
end
