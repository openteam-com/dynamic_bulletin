class CategoryProperty < ActiveRecord::Base
  belongs_to :category
  belongs_to :property
  extend Enumerize
  if self.column_names.include? 'show_as'
    enumerize :show_as, in: [:check_boxes, :radio_buttons, :select]
  end
end

