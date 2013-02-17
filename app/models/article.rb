class Article < ActiveRecord::Base
  has_one :content, :class_name => "ArticleContent", :dependent => :destroy

  before_create :set_publish_at
  after_create :make_content
  after_save :save_content

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
end
