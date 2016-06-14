class Image < ActiveRecord::Base
  belongs_to :advert

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }
  validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
end

