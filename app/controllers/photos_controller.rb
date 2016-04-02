class PhotosController < ApplicationController
  before_filter :required_login

  def create
    article = Article.find_by(id: params[:article_id])
    photo = Photo.create!(params[:photo].permit!)
    session[:article_title] = params[:title_for_photo]
    session[:article_body] = params[:body_for_photo] + %Q|![Large](#{photo.image.url(:large)})\n|

    if article
      redirect_to edit_article_path(article)
    else
      redirect_to new_article_path
    end
  end
end
