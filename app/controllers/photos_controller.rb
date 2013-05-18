class PhotosController < ApplicationController
  before_filter :required_login, only: :create

  def create                                                                                          
    article = Article.find_by_id(params[:article_id])
    photo = Photo.create!(params[:photo].permit!)
    hash = {backup_article_title: params[:backup_article_title], backup_article_body: params[:backup_article_body] + "[p:#{photo.id}]\n"}

    if article
      redirect_to edit_article_path(article, hash)                                                    
    else
      redirect_to new_article_path(hash) 
    end
  end              
end
