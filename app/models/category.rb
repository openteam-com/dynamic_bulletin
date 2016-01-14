class Category < ActiveRecord::Base
  has_many :adverts
  has_many :attributes
end
