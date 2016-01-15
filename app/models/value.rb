class Value < ActiveRecord::Base
  belongs_to :advert
  belongs_to :propertiable, polymorphic: true

  def value
  end

end

# == Schema Information
#
# Table name: values
#
#  id           :integer          not null, primary key
#  advert_id    :integer
#  attribute_id :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
