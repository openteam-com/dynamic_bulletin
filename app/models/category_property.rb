class CategoryProperty < ActiveRecord::Base
  include RankedModel
  ranks :row_order, with_same: :category_id

  scope :by_position, -> { order('row_order') }
  default_scope { by_position }

  belongs_to :category
  belongs_to :property
  extend Enumerize
  if self.column_names.include? 'show_as'
    enumerize :show_as, in: [:check_boxes, :radio_buttons, :select]
  end
end

