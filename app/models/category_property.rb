class CategoryProperty < ActiveRecord::Base
  belongs_to :category
  belongs_to :property

  include RankedModel
  ranks :row_order, with_same: :category_id
  scope :by_position, -> { order('row_order') }
  default_scope { by_position }
end

# == Schema Information
#
# Table name: category_properties
#
#  id                :integer          not null, primary key
#  category_id       :integer
#  property_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  show_on_public    :boolean          default(TRUE)
#  necessarily       :boolean          default(FALSE)
#  show_as           :string           default("check_boxes")
#  row_order         :integer
#  show_on_filter_as :string
#
