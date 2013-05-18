class Article < ActiveRecord::Base
  has_one :content, :class_name => "ArticleContent", :dependent => :destroy

  before_create :set_publish_at
  after_create :make_content
  after_save :save_content

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
  end

  def body
    self.content.try(:body) || ""
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

  def photo_size
    rank == RANK[:top] ? :large : :medium
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

  def plain_body
    @_plain_body ||= body.gsub(/[\r\n]/, "").gsub(/>\|.*?\|.+?\|\|</, "")
  end
end
