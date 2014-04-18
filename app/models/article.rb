class Article < ActiveRecord::Base
  has_one :content, :class_name => "ArticleContent", :dependent => :destroy
  has_many :article_keywords, :dependent => :destroy
  has_many :keywords, :through => :article_keywords

  before_create :set_publish_at
  after_save :keyword_check

  accepts_nested_attributes_for :content, :allow_destroy => true

  scope :published, -> { where("publish_at <= ?", Time.now) }
  scope :newest, -> { order("publish_at DESC, id DESC") }
  scope :oldest, -> { order("publish_at, id") }

  class << self
    def recent_articles(limit = 10)
      self.includes(:content).newest.limit(limit)
    end

    def popular(limit = 100)
      self.includes(:content).order("access_count DESC").limit(limit)
    end

    def period(start, range)
      period_end_method = (range == :day ? :end_of_day : :end_of_month)
      finish = start.__send__(period_end_method)
      period = (start..finish)

      self.includes(:content).where(publish_at: period).oldest
    end

    def calendar
      self.select(
        "YEAR(publish_at) as year, MONTH(publish_at) as month, count(*) as count"
      ).group("year, month").order("publish_at")
    end

    def paginate_by_publish(page_num)
      newest.page(page_num)
    end
  end

  def prev_article(user = nil)
    articles = user ? user.articles : self.class.default_scoped
    @prev_article ||= articles.where("publish_at <= ? AND id <> ?", publish_at, id).newest.first
  end

  def next_article(user = nil)
    articles = user ? user.articles : self.class.default_scoped
    @next_article ||= articles.where("publish_at >= ? AND id <> ?", publish_at, id).oldest.first
  end

  def body
    content.try(:body) || ""
  end

  def digest_body(length = 180)
    @_digest_body ||= plain_body.gsub(/(\[.+?\]|\<.+?\>)/, "").truncate(length)
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

  def keyword_check
    keyword_list = Keyword.search(body)
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
