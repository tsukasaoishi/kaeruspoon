class PhotosController < ApplicationController
  before_filter :required_login

  def create
    article = Article.find_by_id(params[:article_id])
    photo = Photo.create!(params[:photo].permit!)
    session[:backup_article_title] = params[:backup_article_title]
    session[:backup_article_body] = params[:backup_article_body] + %Q|![Large](#{photo.image.url(:large)})\n|

    if article
      redirect_to edit_article_path(article)
    else
      redirect_to new_article_path
    end
  end
end
