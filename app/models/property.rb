class Property < ActiveRecord::Base


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
  enumerize :kind, in: [:string, :integer, :float, :limited_list, :unlimited_list, :hierarch_limited_list]
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
