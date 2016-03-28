class ArticlesController < ApplicationController
  before_filter :required_login, only: [:new, :create, :edit, :update, :destroy]

  caches_action :index, expires_in: 1.month, if: lambda{ !logged_in? }
  caches_action :show, expires_in: 1.month, if: -> { !logged_in? }
  caches_action :popular, expires_in: 1.week, if: -> { !logged_in? }

  def index
    @entrance = true
    @articles = current_user.recent_articles(7)
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
    if @articles.present?
      @prev_article = @articles.first.prev_article(current_user)
      @next_article = @articles.last.next_article(current_user)
    end

    @title = I18n.l(start, format: date_range)
    render "index"
  end

  def archive
    @calendar = Article.archive_articles
    @title = I18n.t(:archive_articles)
  end

  def show
    @article = current_user.articles.find(params[:id])
    @digest_body = TextDecorator.replace_without_tags(@article.digest_body)
    @title = @article.title
  end

  def new
    title, body = repair_article
    @article = Article.new(title: title, publish_at: Time.now)
    @article.build_content(body: body)
  end

  def create
    article = Article.create!(require_params)
    expire_actions(article)

    redirect_to article
  end

  def edit
    @article = Article.find(params[:id])

    title, body = repair_article
    if title
      @article.title = title
      @article.body = body
    end

    render "new"
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes!(require_params)
    expire_actions(article)

    redirect_to article
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    expire_actions(article)

    redirect_to root_path
  end

  private

  def require_params
    params.require(:article).permit(:title, :publish_at, content_attributes: [:body])
  end

  def repair_article
    title = session[:article_title]
    body = session[:article_body]
    session[:article_title] = nil
    session[:article_body] = nil
    [title, body]
  end

  def expire_actions(article)
    expire_action(article)
    expire_action(article.prev_article) if article.prev_article
    expire_action(article.next_article) if article.next_article
    expire_action(controller: :articles, action: :index)
    expire_action(controller: :articles, action: :index, format: :atom)
  end
end
