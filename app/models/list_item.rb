# == Schema Information
#
# Table name: list_items
#
#  id                :integer          not null, primary key
#  title             :string
#  propertiable_id   :integer
#  propertiable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ListItem < ActiveRecord::Base
  belongs_to :propertiable, polymorphic: true
end
