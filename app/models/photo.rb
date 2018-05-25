class Photo < ApplicationRecord
  before_destroy :destroy_image

  has_attached_file :image,
    styles: {
      large: "720x720",
      portrait: "480x480",
      medium: "320x320"
    },
    storage: :s3,
    s3_credentials: {
      access_key_id: Rails.application.credentials.s3[:access_key_id],
      secret_access_key: Rails.application.credentials.s3[:secret_access_key],
      s3_host_name: "s3-ap-northeast-1.amazonaws.com",
      bucket: Rails.env.production? ? "kaeruspoon" : "kaeruspoondevelopment",
    },
    path: ":attachment/:id/:style.:extension",
    s3_protocol: :https,
    s3_region: "ap-northeast-1"

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  private

  def destroy_image
    image.destroy
  end
end
