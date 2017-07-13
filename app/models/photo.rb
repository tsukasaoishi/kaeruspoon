class Photo < ApplicationRecord
  before_destroy :destroy_image

  has_attached_file :image,
    styles: {
      large: "720x720",
      portrait: "480x480",
      medium: "320x320"
    },
    storage: :s3,
    s3_credentials: Rails.application.secrets.s3,
    path: ":attachment/:id/:style.:extension",
    s3_protocol: :https

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  private

  def destroy_image
    image.destroy
  end
end
