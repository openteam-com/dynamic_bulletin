class Value < ActiveRecord::Base
  belongs_to :advert
  belongs_to :property
  belongs_to :list_item

  def value
  end

end

# == Schema Information
#
# Table name: values
#
#  id           :integer          not null, primary key
#  advert_id    :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  string_value :string
#  property_id  :string
#
