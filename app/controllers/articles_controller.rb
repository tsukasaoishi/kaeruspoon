require Rails.root.join("lib/text_decorator")

class ArticlesController < ApplicationController
  before_action :required_login, only: %i(new create edit update destroy)
  after_action :expire_cache, only: %i(create update destroy)

  caches_action :index, expires_in: 1.month
  caches_action :show, expires_in: 1.month, if: -> { !logged_in? }

  def index
    respond_to do |format|
      format.html {
        @articles = Article.recent_articles(30)
        @tite = "最新記事"
      }
      format.atom { @articles = Article.recent_articles(30, only_share: true).to_a }
    end
  end

  def show
    @article = Article.find(params[:id])
    @digest_body = TextDecorator.replace_without_tags(@article.digest_body)
    @title = @article.title
  end

  def new
    title, body = repair_article
    @article = Article.new(title: title, publish_at: Time.current)
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
    title = session[:article_title] && session[:article_title].dup
    body = session[:article_body] && session[:article_body].dup
    session[:article_title] = nil
    session[:article_body] = nil
    [title, body]
  end

  def expire_cache
    Rails.cache.clear
  end
end
