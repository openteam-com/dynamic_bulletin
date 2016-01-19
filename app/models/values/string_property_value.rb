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

class StringPropertyValue < Value
  def value
    string_value
  end
end
