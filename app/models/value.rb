class Value < ActiveRecord::Base
  attr_accessor :hierarch_list_item_parent_id

  belongs_to :advert
  belongs_to :property
  belongs_to :list_item
  belongs_to :hierarch_list_item

  has_many :list_item_values
  has_many :list_items, through: :list_item_values

  validates_presence_of :string_value, if: :property_necessarily_set_for_string?
  validates_presence_of :integer_value, if: :property_necessarily_set_for_integer?
  validates_presence_of :list_item, if: :property_necessarily_set_for_limited_list?
  validates_presence_of :hierarch_list_item, if: :property_necessarily_set_for_hierarch_limited_list?
  #validates_presence_of :list_items#,
  validate :presence_of_list_items

  validates_uniqueness_of :property_id, scope: :advert_id

  def value
    case property.kind.to_sym
    when :string
      string_value
    when :integer
      integer_value
    when :limited_list
      list_item
    when :unlimited_list
      list_items
    when :hierarch_limited_list
      hierarch_list_item
    else
      ''
    end
  end

  #Property.kind.values
  def property_necessarily_set_for_string?
    property.necessarily && property.kind == 'string'
  end

  def property_necessarily_set_for_integer?
    property.necessarily && property.kind == 'integer'
  end

  def property_necessarily_set_for_limited_list?
    property.necessarily && property.kind == 'limited_list'
  end

  def property_necessarily_set_for_unlimited_list?
    property.necessarily && property.kind == 'unlimited_list'
  end

  def property_necessarily_set_for_hierarch_limited_list?
    property.necessarily && property.kind == 'hierarch_limited_list'
  end

  def presence_of_list_items
    errors.add(:list_items, 'ola') if list_items.empty?
  end
end

# == Schema Information
#
# Table name: values
#
#  id                    :integer          not null, primary key
#  advert_id             :integer
#  property_id           :integer
#  string_value          :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  list_item_id          :integer
#  integer_value         :integer
#  hierarch_list_item_id :integer
#
