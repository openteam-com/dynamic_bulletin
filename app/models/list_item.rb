# == Schema Information
#
# Table name: list_items
#
#  id          :integer          not null, primary key
#  title       :string
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ListItem < ActiveRecord::Base
  belongs_to :property

  alias_attribute :to_s, :title
end
