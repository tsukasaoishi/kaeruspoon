class Article < ApplicationRecord
  has_one :content, class_name: "ArticleContent", dependent: :destroy

  has_many :article_keywords, dependent: :destroy
  has_many :keywords, through: :article_keywords

  has_one :article_photo, dependent: :destroy
  has_one :pickup_photo, through: :article_photo, source: :photo

  has_many :related_articles, dependent: :destroy
  has_many :similar_articles, through: :related_articles, source: :related_article

  has_one :share_to_sns

  before_create :set_publish_at
  after_save :keyword_check!, :choose_pickup_photo!, :choose_similar_articles!

  accepts_nested_attributes_for :content, allow_destroy: true

  scope :published, -> { where("articles.publish_at <= ?", Time.current) }
  scope :newest, -> { order("articles.publish_at DESC, articles.id DESC") }
  scope :oldest, -> { order("articles.publish_at, articles.id") }

  class << self
    def recent_articles(limit = 10)
      newest.limit(limit).preload(:content)
    end

    def popular_articles(limit = 100)
      where("access_count > ?", 0).order("access_count DESC").limit(limit).preload(:content)
    end

    def period_articles(start, range, reverse = false)
      period_end_method = (range == :day ? :end_of_day : :end_of_month)
      finish = start.__send__(period_end_method)
      period = (start..finish)

      list = where(publish_at: period).preload(:content)
      reverse ? list.newest : list.oldest
    end

    def paginate_by_publish(page_num)
      newest.page(page_num)
    end

    def archive_articles
      select(
        "YEAR(publish_at + INTERVAL 9 HOUR) as year, MONTH(publish_at + INTERVAL 9 HOUR) as month, count(*) as count"
      ).group("year, month").order("year, month")
    end
  end

  def to_date_hash
    {year: publish_at.year, month: publish_at.month}
  end

  def prev_article
    @prev_article ||=
      self.class.where("publish_at <= ? AND id < ?", publish_at, id).newest.first
  end

  def next_article
    @next_article ||=
      self.class.where("publish_at >= ? AND id > ?", publish_at, id).oldest.first
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

  def share_to
    !!share_to_sns
  end

  def share_to=(flag)
    if flag
      return if share_to_sns
      create_share_to_sns
    else
      return unless share_to_sns
      share_to_sns.destroy
    end
  end

  def digest_body
    @_digest_body ||= body.split(/\r|\n|\r\n/).delete_if{|text| text.blank? || text =~ /^!/}.first || ""
  end

  def choose_pickup_photo!
    photo_id = body.scan(%r!\(https://s3.+?amazonaws.com/.+?/images/(\d+)/.+?\.jpg.+?\)!i).flatten.first
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

    article_ids = list.compact.uniq.map(&:id)
    old_ids = related_articles.map(&:related_article_id)
    delete_ids = old_ids - article_ids
    create_ids = article_ids - old_ids

    related_articles.where(related_article_id: delete_ids).each(&:destroy)
    create_ids.each do |id|
      related_articles.create!(related_article_id: id)
    end
  end

  def keyword_check!
    keyword_list = Keyword.search(body)
    self.keywords = Keyword.where(name: keyword_list).to_a
  end

  private

  def set_publish_at
    self.publish_at ||= Time.current
  end
end
