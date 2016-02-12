class Property < ActiveRecord::Base
  include RankedModel
  ranks :row_order, with_same: :category_id

  scope :by_position, -> { order('row_order') }
  scope :with_public, -> { where(show_on_public: true) }
  scope :filterable, -> { where(kind: [:limited_list, :unlimited_list, :hierarch_limited_list]) }

  default_scope { by_position }

  belongs_to :category

  has_many :values, dependent: :destroy
  has_many :list_items, dependent: :destroy
  has_many :hierarch_list_items, dependent: :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :list_items, allow_destroy: true
  accepts_nested_attributes_for :hierarch_list_items, allow_destroy: true

  alias_attribute :to_s, :title

  extend Enumerize
  enumerize :kind, in: [:string, :limited_list, :unlimited_list, :integer, :hierarch_limited_list]
  enumerize :show_as, in: [:check_boxes, :radio_buttons, :select]

  default_value_for :show_on_public, true
  default_value_for :show_as, :check_boxes
end

# == Schema Information
#
# Table name: properties
#
#  id             :integer          not null, primary key
#  kind           :string
#  title          :string
#  category_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  row_order      :integer
#  show_on_public :boolean          default(TRUE)
#  show_as        :string           default("check_boxes")
#
