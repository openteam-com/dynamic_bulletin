class Image < ActiveRecord::Base
  belongs_to :advert
  has_attached_file :image
  validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }
end

