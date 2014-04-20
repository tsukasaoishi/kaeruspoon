module Tasks
  class ArticleCountAnalyzeBase < JobBase
    def initialize(*access_logs)
      @access_logs = access_logs
      @articles_count = Hash.new(0)
    end

    def run
      @access_logs.each do |access_log|
        check_article_count(access_log)
      end

      save_article_count
    end

    private

    def check_article_count(access_log)
      File.open(access_log, "r") do |f|
        f.each do |line|
          analyze_line(line.strip)
        end
      end
    end

    def analyze_line(line)
      raise "must analyze line and set to @accesss_count"
    end

    def save_article_count
      Article.where(id: @articles_count.keys).each do |article|
        article.access_count += @articles_count[article.id]
        article.save
      end
    end

    def checked_time_file
      File.join(Rails.root, "tmp/checked_time")
    end
  end
end
