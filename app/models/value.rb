class Value < ActiveRecord::Base
  belongs_to :advert
  belongs_to :attribute_category
end
