module Tasks
  class ArticleContentAnalyze < JobBase
    def run
      contents = ArticleContent.where("updated_at > ?", checked_time)
      return unless latest_content = contents.order("updated_at DESC").select(:updated_at).first
      @latest_time = latest_content.updated_at
      article_ids = contents.select(:article_id).map(&:article_id)

      Article.includes(:content, :keywords).where(id: article_ids).each do |article|
        article.keyword_check!
        article.choose_similar_articles!
        article.choose_pickup_photo!
      end
    end

    private

    def checked_time_file
      File.join(Rails.root, "tmp/article_content_analyze_time")
    end
  end
end
