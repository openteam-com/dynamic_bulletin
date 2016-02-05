class Value < ActiveRecord::Base
  attr_accessor :hierarch_list_item_parent_id

  belongs_to :advert
  belongs_to :property
  belongs_to :list_item
  belongs_to :hierarch_list_item

  has_many :list_item_values
  has_many :list_items, through: :list_item_values

  validates_uniqueness_of :property_id, scope: :advert_id

  def value
    case property.kind.to_sym
    when :string
      string_value
    when :integer
      integer_value
    when :limited_list
      list_item
    when :hierarch_limited_list
      hierarch_list_item
    else
      ''
    end
  end

end

# == Schema Information
#
# Table name: values
#
#  id            :integer          not null, primary key
#  advert_id     :integer
#  property_id   :integer
#  string_value  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  list_item_id  :integer
#  integer_value :integer
#
