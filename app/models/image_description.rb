class ImageDescription < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :image

  # méthode pour JSON
  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if image.attached?
  end
end
