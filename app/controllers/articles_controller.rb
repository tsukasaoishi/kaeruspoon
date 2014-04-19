class ArticlesController < ApplicationController
  before_filter :required_login, only: [:new, :create, :edit, :update, :destroy]

  caches_action :show, expires_in: 1.day, if: -> { !logged_in? }

  def index
    @articles = current_user.articles.recent_articles(10)
  end

  def popular
    @articles = current_user.articles.popular(100)

    @title = I18n.t(:popular_articles)
    render "index"
  end

  def date
    y, m, d = params.values_at(:year, :month, :day)
    date_range = d ? :day : :month
    start = Time.local(y, m, d || 1)
    @articles = current_user.articles.period(start, date_range)

    @title = I18n.l(start, format: date_range)
    render "index"
  end

  def archive
    @calendar = Article.calendar
    @title = I18n.t(:archive_articles)
  end

  def show
    @article = current_user.articles.find(params[:id])
    @title = @article.title
  end

  def new
    @article = Article.new(title: params[:backup_article_title], publish_at: Time.now)
    @article.build_content(body: params[:backup_article_body])
  end

  def create
    article = Article.create!(require_params)
    expire_action(article.prev_article) if article.prev_article
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
    expire_action(article)
    redirect_to article
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    redirect_to root_path
  end

  private

  def require_params
    params.require(:article).permit(:title, :publish_at, content_attributes: [:body])
  end
end
