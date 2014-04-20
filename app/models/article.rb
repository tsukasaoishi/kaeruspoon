class Article < ActiveRecord::Base
  has_one :content, :class_name => "ArticleContent", :dependent => :destroy
  has_many :article_keywords, :dependent => :destroy
  has_many :keywords, :through => :article_keywords
  has_one :article_photo, :dependent => :destroy
  has_one :pickup_photo, :through => :article_photo, :source => :photo
  has_many :related_articles, :dependent => :destroy
  has_many :similar_articles, :through => :related_articles, :source => :related_article

  before_create :set_publish_at

  accepts_nested_attributes_for :content, :allow_destroy => true

  scope :published, -> { where("publish_at <= ?", Time.now) }
  scope :newest, -> { order("publish_at DESC, id DESC") }
  scope :oldest, -> { order("publish_at, id") }

  class << self
    def recent_articles(limit = 10)
      self.includes(:content).newest.limit(limit)
    end

    def popular_articles(limit = 100)
      self.includes(:content).order("access_count DESC").limit(limit)
    end

    def period_articles(start, range)
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
    @prev_article ||= begin
      articles = user ? user.articles : self.class.default_scoped
      articles.where("publish_at <= ? AND id <> ?", publish_at, id).newest.first
    end
  end

  def next_article(user = nil)
    @next_article ||= begin
      articles = user ? user.articles : self.class.default_scoped
      articles.where("publish_at >= ? AND id <> ?", publish_at, id).oldest.first
    end
  end

  def body
    content.try(:body) || ""
  end

  def body=(text)
    if content
      content.body = text
    else
      build_content(body: text)
    end
  end

  def digest_body(length = 180)
    @_digest_body ||= plain_body.gsub(/(\[.+?\]|\<.+?\>)/, "").truncate(length)
  end

  def choose_pickup_photo!
    photo_id = plain_body.scan(/\[p\:(\d+)\]/).flatten.first
    photo = Photo.find_by_id(photo_id) if photo_id
    self.pickup_photo = photo
  end

  def choose_similar_articles!
    list = []
    keywords[0..9].each do |k|
      k_scope = k.articles.published
      list << k_scope.where("articles.publish_at < ?", self.publish_at).newest.first
      list << k_scope.where("articles.publish_at > ?", self.publish_at).oldest.first
    end
    self.similar_articles = list.compact.uniq
  end

  def keyword_check!
    keyword_list = Keyword.search(body)
    self.keywords = Keyword.where(:name => keyword_list).to_a
  end

  private

  def set_publish_at
    self.publish_at ||= Time.now
  end

  def plain_body
    @_plain_body ||= body.gsub(/[\r\n]/, "").gsub(/>\|.*?\|.+?\|\|</, "")
  end
end
