class CategoryProperty < ActiveRecord::Base
  belongs_to :category
  belongs_to :property
  extend Enumerize
  enumerize :show_as, in: [:check_boxes, :radio_buttons, :select]
end
