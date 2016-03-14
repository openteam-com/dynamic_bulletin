class Property < ActiveRecord::Base
  #include RankedModel
  #ranks :row_order, with_same: :category_id

  scope :by_position, -> { order('row_order') }
  scope :filterable, -> { where(kind: [:limited_list, :unlimited_list, :hierarch_limited_list]) }

  default_scope { by_position }

  #belongs_to :category

  has_many :values, dependent: :destroy
  has_many :list_items, dependent: :destroy
  has_many :hierarch_list_items, dependent: :destroy

  has_many :category_properties, dependent: :destroy
  has_many :categories, through: :category_properties

  validates_presence_of :title

  accepts_nested_attributes_for :list_items, allow_destroy: true
  accepts_nested_attributes_for :category_properties, allow_destroy: true
  accepts_nested_attributes_for :hierarch_list_items, allow_destroy: true

  alias_attribute :to_s, :title

  extend Enumerize
  enumerize :kind, in: [:string, :integer, :limited_list, :unlimited_list, :hierarch_limited_list]
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
#  necessarily    :boolean          default(FALSE)
#
