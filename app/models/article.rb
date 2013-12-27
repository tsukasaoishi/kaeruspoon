class Article < ActiveRecord::Base
  has_one :content, :class_name => "ArticleContent", :dependent => :destroy
  has_many :article_keywords, :dependent => :destroy
  has_many :keywords, :through => :article_keywords

  before_create :set_publish_at
  after_create :make_content
  after_save :save_content, :keyword_check

  RANK = {
    top: 3,
    middle: 2,
    low: 1
  }

  class << self
    def calc_rank(articles)
      max = articles.max_by{|a| a.access_count}.access_count
      min = articles.min_by{|a| a.access_count}.access_count
      border = (max - min).to_f / 3
      first_border = min + border
      articles.each do |article|
        case article.access_count
        when (first_border...(first_border + border))
          article.middle_rank!
        when ((first_border + border)..max)
          article.top_rank!
        end
      end
    end

    def find_archives
      archives = []
      next_month = Time.at(0)
      while a = self.where(["created_at >= ?", next_month]).order("created_at").first
        archives << {:year => a.publish_at.year, :month => a.publish_at.month}
        next_month = a.publish_at.next_month.beginning_of_month
      end
      archives
    end
  end

  def body
    self.content.try(:body) || @_body || ""
  end

  def body=(text)
    if self.content
      self.content.body = text
    else
      @_body = text
    end
  end


  def prev_article
    @prev_article ||= self.class.where("publish_at <= ? AND id <> ?", publish_at, id).order("publish_at DESC").first
  end

  def next_article
    @next_article ||= self.class.where("publish_at >= ? AND id <> ?", publish_at, id).order("publish_at ASC").first
  end

  def rank
    @rank || RANK[:low]
  end

  RANK.each do |k, v|
    define_method("#{k}_rank!") do
      @rank = v
    end
  end

  def digest_body(length_base = 60)
    @_digest_body ||= plain_body.gsub(/(\[.+?\]|\<.+?\>)/, "").truncate(length_base * rank)
  end

  def pickup_photo
    @_pickup_photo ||= begin
      photo_id = plain_body.scan(/\[p\:(\d+)\]/).flatten.first
      photo_id && Photo.find_by_id(photo_id)
    end
  end

  def count_up
    if buffer = Rails.cache.read(counter_key)
      count, set_time = buffer.split(":").map{|i| i.to_i}
      count += 1
      if (Time.now.to_i - set_time) > 600
        Rails.cache.delete(counter_key)
        self.access_count += count
        self.save
      else
        write_counter_cache(count, set_time)
      end
    else
      self.access_count += 1
      self.save
      write_counter_cache(0, Time.now.to_i)
    end
  end

  def related_articles
    @related_articles ||=
      begin
        list = []
        keywords[0..9].each do |k|
          k_scope = k.articles.where("articles.publish_at <= ?", Time.now)
          list << k_scope.where("articles.publish_at < ?", self.publish_at).order("articles.publish_at DESC").first
          list << k_scope.where("articles.publish_at > ?", self.publish_at).order("articles.publish_at").first
        end
        list.compact.uniq.sort{|a,b| b.access_count <=> a.access_count}
      end
  end

  private

  def set_publish_at
    self.publish_at ||= Time.now
  end

  def make_content
    self.create_content!(:body => @_body || "")
  end

  def save_content
    self.content.save!
  end

  def keyword_check
    keyword_list = Keyword.search(self.body)
    self.keywords = Keyword.where(:name => keyword_list).to_a
  end

  def plain_body
    @_plain_body ||= body.gsub(/[\r\n]/, "").gsub(/>\|.*?\|.+?\|\|</, "")
  end

  def write_counter_cache(count, set_time)
    Rails.cache.write(counter_key, "#{count}:#{set_time}", expires_in: 4.weeks)
  end

  def counter_key
    "Articles:#{self.id}_count"
  end
end
