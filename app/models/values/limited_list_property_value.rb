# == Schema Information
#
# Table name: values
#
#  id                :integer          not null, primary key
#  advert_id         :integer
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  propertiable_id   :integer
#  propertiable_type :string
#  string_value      :string
#

class LimitedListPropertyValue < Value
  belongs_to :list_item
  def value
    list_item.title
  end
end
