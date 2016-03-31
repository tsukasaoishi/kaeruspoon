class ArticlesController < ApplicationController
  before_filter :required_login, only: [:new, :create, :edit, :update, :destroy]
  after_filter :expire_cache, only: %i(create update destroy)

  caches_action :index, expires_in: 1.month, if: lambda{ !logged_in? }
  caches_action :show, expires_in: 1.month, if: -> { !logged_in? }

  def index
    @entrance = true

    respond_to do |format|
      format.html { @articles = current_user.recent_articles(7) }
      format.atom { @articles = User.guest.recent_articles(7, only_share: true).to_a }
    end
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

    redirect_to article
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy

    redirect_to root_path
  end

  private

  def require_params
    params.require(:article).permit(
      :title,
      :publish_at,
      :not_to_share,
      content_attributes: [:body],
    )
  end

  def repair_article
    title = session[:article_title]
    body = session[:article_body]
    session[:article_title] = nil
    session[:article_body] = nil
    [title, body]
  end

  def expire_cache
    Rails.cache.clear
  end
end
