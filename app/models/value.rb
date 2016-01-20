class Value < ActiveRecord::Base
  belongs_to :advert
  belongs_to :property
  belongs_to :list_item
  validates_uniqueness_of :property_id, scope: :advert_id

  def value
    case property.kind.to_sym
    when :string
      string_value
    when :limited_list
      list_item
    else
      ''
    end
  end

end

# == Schema Information
#
# Table name: values
#
#  id           :integer          not null, primary key
#  advert_id    :integer
#  property_id  :integer
#  string_value :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  list_item_id :integer
#
