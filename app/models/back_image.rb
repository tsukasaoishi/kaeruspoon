class BackImage < ActiveRecord::Base
  before_destroy :destroy_image

  has_attached_file :image,
    styles: {
      original: "1600x1600"
    },
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/s3.yml",
    path: ":attachment/background/:id/:style.:extension"

  class << self
    def url
      return "" unless self.last
      self.last.image.url
    end
  end

  private

  def destroy_image
    self.image.destroy
  end
end
