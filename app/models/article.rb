class Article < ActiveRecord::Base
  has_one :content, :class_name => "ArticleContent", :dependent => :destroy
  has_many :article_keywords, :dependent => :destroy
  has_many :keywords, :through => :article_keywords
  has_one :article_photo, :dependent => :destroy
  has_one :pickup_photo, :through => :article_photo, :source => :photo
  has_many :related_articles, :dependent => :destroy
  has_many :similar_articles, :through => :related_articles, :source => :related_article

  before_create :set_publish_at
  after_save :keyword_check!, :choose_pickup_photo!, :choose_similar_articles!

  accepts_nested_attributes_for :content, :allow_destroy => true

  scope :published, -> { where("publish_at <= ?", Time.now) }
  scope :newest, -> { order("publish_at DESC, id DESC") }
  scope :oldest, -> { order("publish_at, id") }

  class << self
    def recent_articles(limit = 10)
      includes(:content, :pickup_photo).newest.limit(limit)
    end

    def popular_articles(limit = 100)
      includes(:content, :pickup_photo).order("access_count DESC").limit(limit)
    end

    def period_articles(start, range, reverse = false)
      period_end_method = (range == :day ? :end_of_day : :end_of_month)
      finish = start.__send__(period_end_method)
      period = (start..finish)

      list = includes(:content, :pickup_photo).where(publish_at: period)
      reverse ? list.newest : list.oldest
    end

    def paginate_by_publish(page_num)
      newest.page(page_num)
    end

    def archive_articles
      select(
        "YEAR(publish_at + INTERVAL 9 HOUR) as year, MONTH(publish_at + INTERVAL 9 HOUR) as month, count(*) as count"
      ).group("year, month").order("publish_at")
    end
  end

  def to_date_hash
    {year: publish_at.year, month: publish_at.month}
  end

  def prev_article(user = nil)
    @prev_article ||=
      neighbor_article_scope(user).where("publish_at <= ? AND id <> ?", publish_at, id).newest.first
  end

  def next_article(user = nil)
    @next_article ||=
      neighbor_article_scope(user).where("publish_at >= ? AND id <> ?", publish_at, id).oldest.first
  end

  def body
    content ? content.body : ""
  end

  def body=(text)
    if content
      content.body = text
    else
      build_content(body: text)
    end
  end

  def digest_body(length = 180)
    @_digest_body ||= body.split(/\r|\n|\r\n/).delete_if{|text| text.blank? || text =~ /^!/}.first
  end

  def choose_pickup_photo!
    photo_id = body.scan(%r!\(http://s3.+?amazonaws.com/.+?/images/(\d+)/.+?\.jpg.+?\)!i).flatten.first
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

  def neighbor_article_scope(user)
    user ? user.articles : self.class.default_scoped
  end
end
