class AmazonController < ApplicationController
  def markdown
    article_body = params[:backup_article_body_for_amazon].dup

    if amazon = AmazonStock.find_by_asin(params[:asin])
      case params[:amazon_type].to_s
      when "title"
        article_body += %Q|[「#{amazon.product_name}」](#{amazon.url})|
      when "image"
        article_body += %Q|![Amazon](#{amazon.medium_image_url})|
      end
    end

    session[:backup_article_title] = params[:backup_article_title_for_amazon]
    session[:backup_article_body] = article_body
    if article = Article.find_by_id(params[:article_id])
      redirect_to edit_article_path(article)
    else
      redirect_to new_article_path
    end
  end
end
