class Photo < ActiveRecord::Base
  before_destroy :destroy_image

  has_attached_file :image,
    :styles => {
    :large => "640x640",
    :medium => "320x320",
    :original => "1200x1200"
  },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":attachment/:id/:style.:extension"

  private

  def destroy_image
    self.image.destroy
  end
end
