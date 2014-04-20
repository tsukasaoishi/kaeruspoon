module Tasks
  class ArticleContentAnalyze < JobBase
    def run
      article_ids = ArticleContent.where("updated_at > ?", checked_time).select("article_id").map(&:article_id)
      Article.includes(:content, :keywords).where(id: article_ids).each do |article|
        article.keyword_check!
        article.choose_similar_articles!
        article.choose_pickup_photo!
        @latest_time = article.content.updated_at if !@latest_time || @latest_time > article.content.updated_at
      end
    end

    private

    def checked_time_file
      File.join(Rails.root, "tmp/article_content_analyze_time")
    end
  end
end
