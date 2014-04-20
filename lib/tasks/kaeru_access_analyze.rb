module Tasks
  class KaeruAccessAnalyze < ArticleCountAnalyzeBase
    private

    def analyze_line(line)
      if line =~ %r!\[([^\]]+)\]\s+"GET\s+/articles/(\d+)\s+HTTP/\d\.\d"\s+(\d+)\s!
        work = $1.split(":", 2)
        time = Time.parse(work.join(" ")) rescue nil
        return if !time || time <= checked_time
        article_id, code = [$2, $3].map{|item| item.to_i}
        return if article_id == 0
        return unless (200...400).include?(code)
        @latest_time = time if !@latest_time ||  time > @latest_time
        @articles_count[article_id] += 1
      end
    end
  end
end
