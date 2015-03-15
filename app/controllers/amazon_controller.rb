class AmazonController < ApplicationController
  def markdown
    session[:article_title] = params[:title_for_amazon]
    session[:article_body] = params[:body_for_amazon] +
      AmazonStock.add_content(params[:asin], params[:amazon_type])

    article = Article.find_by_id(params[:article_id])
    redirect_to(article ? edit_article_path(article) : new_article_path)
  end
end
