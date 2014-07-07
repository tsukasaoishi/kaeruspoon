class AmazonController < ApplicationController
  def markdown
    article_body = params[:backup_article_body_for_amazon].dup

    if amazon = AmazonStock.find_by_asin(params[:asin])
      if params[:amazon_type][:image]
        article_body += %Q|[![Amazon](#{amazon.medium_image_url})](#{amazon.url})|
      end

      if params[:amazon_type][:title]
        article_body += %Q|[「#{amazon.product_name}」](#{amazon.url})|
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
