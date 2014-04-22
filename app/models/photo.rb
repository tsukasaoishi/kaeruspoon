class Photo < ActiveRecord::Base
  before_destroy :destroy_image

  has_attached_file :image,
    styles: {
      large: "720x720",
      portrait: "480x480",
      medium: "320x320"
    },
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/s3.yml",
    path: ":attachment/:id/:style.:extension"

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  private

  def destroy_image
    self.image.destroy
  end
end
