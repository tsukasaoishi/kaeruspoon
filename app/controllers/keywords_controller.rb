class KeywordsController < ApplicationController
  def show
    raise ActiveRecord::RecordNotFound unless @keyword = Keyword.where(:name => params[:id]).first
    @title = @keyword.name
    @articles = @keyword.articles.paginate(:order => "articles.publish_at DESC", :per_page => 20, :page => params[:page])
  end
end
