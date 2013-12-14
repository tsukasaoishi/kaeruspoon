class KeywordsController < ApplicationController
  before_filter :required_login, only: [:new, :create, :edit, :update, :destroy]

  caches_action :show, expires_in: 1.day, if: lambda{ !logged_in? }

  def show
    @keyword = Keyword.where(:name => params[:id]).first ||
      Keyword.new(:name => params[:id])
    @title = @keyword.name
    @articles = @keyword.articles.paginate(:order => "articles.publish_at DESC", :per_page => 20, :page => params[:page])

    @wiki_content = Wikipedia.find(@keyword.name).sample_content
  end

  def new
    @keyword = Keyword.new
  end

  def create
    keyword = Keyword.create!(require_params)
    redirect_to keyword_path(:id => keyword.name)
  end

  def edit
    @keyword = Keyword.find(params[:id])
    render "new"
  end

  def update
    keyword = Keyword.find(params[:id])
    keyword.update_attributes!(require_params)
    expire_action(action: :show, id: keyword.name)
    redirect_to keyword_path(:id => keyword.name)
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
