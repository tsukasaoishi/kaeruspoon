class ArticlesController < ApplicationController
  before_filter :required_login, only: [:new, :create, :edit, :update, :destroy]

  caches_action :index, expires_in: 1.day, if: lambda{ !logged_in? }
  caches_action :popular, expires_in: 1.day, if: -> { !logged_in? }
  caches_action :show, expires_in: 1.day, if: -> { !logged_in? }

  def index
    @articles = current_user.recent_articles(30)
  end

  def popular
    @articles = current_user.popular_articles(20)

    @title = I18n.t(:popular_articles)
    render "index"
  end

  def date
    y, m, d = params.values_at(:year, :month, :day)
    date_range = d ? :day : :month
    start = Time.local(y, m, d || 1)
    @articles = current_user.period_articles(start, date_range)

    @title = I18n.l(start, format: date_range)
    render "index"
  end

  def archive
    @calendar = Article.archive_articles
    @title = I18n.t(:archive_articles)
  end

  def show
    @article = current_user.articles.find(params[:id])
    @title = @article.title
  end

  def new
    title, body = repair_article
    @article = Article.new(title: title, publish_at: Time.now)
    @article.build_content(body: body)
    @categories = Article.categories
  end

  def create
    article = Article.create!(require_params)
    expire_action(article.prev_article) if article.prev_article
    expire_index_action

    redirect_to article
  end

  def edit
    @article = Article.find(params[:id])

    title, body = repair_article
    if title
      @article.title = title
      @article.body = body
    end

    @categories = Article.categories

    render "new"
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes!(require_params)
    expire_action(article)
    expire_action(article.prev_article) if article.prev_article
    expire_action(article.next_article) if article.next_article
    expire_index_action

    redirect_to article
  end

  def destroy
    article = Article.find(params[:id])
    prev_article = article.prev_article
    next_article = article.next_article

    expire_action(article)
    article.destroy

    expire_action(prev_article) if prev_article
    expire_action(next_article) if next_article
    expire_index_action

    redirect_to root_path
  end

  private

  def require_params
    params.require(:article).permit(:title, :publish_at, content_attributes: [:body])
  end

  def repair_article
    title = session[:backup_article_title]
    body = session[:backup_article_body]
    session[:backup_article_title] = nil
    session[:backup_article_body] = nil
    [title, body]
  end

  def expire_index_action
    expire_action(action: :index)
    expire_action(action: :index, format: :atom)
  end
end
