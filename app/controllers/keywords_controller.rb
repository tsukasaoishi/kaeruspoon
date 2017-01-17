require Rails.root.join("lib/text_decorator")

class KeywordsController < ApplicationController
  before_action :required_login, except: :show

  def show
    @keyword = Keyword.where(name: params[:id]).first_or_initialize
    @title = @keyword.name
    @articles = @keyword.paginate_articles(params[:page])

    @wiki_content = Rails.cache.fetch("wikipedia:#{@keyword.name}", expires_in: 1.day) do
      Wikipedia.find(@keyword.name).sample_content rescue nil
    end

    @sub_title = "キーワード"
  end

  def new
    @keyword = Keyword.new
  end

  def create
    keyword = Keyword.create!(require_params)
    redirect_to keyword_path(id: keyword.name)
  end

  def edit
    @keyword = Keyword.find(params[:id])
    render "new"
  end

  def update
    keyword = Keyword.find(params[:id])
    keyword.update_attributes!(require_params)
    expire_action(action: :show, id: keyword.name)
    redirect_to keyword_path(id: keyword.name)
  end

  def destroy
    keyword = Keyword.find(params[:id])
    keyword.destroy
    redirect_to root_path
  end

  private

  def require_params
    params.require(:keyword).permit(:name, :body)
  end
end
