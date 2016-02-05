class ListItem < ActiveRecord::Base
  belongs_to :property

  has_many :list_item_values
  has_many :values, through: :list_item_values


  validates :title, uniqueness: { scope: :property_id }

  alias_attribute :to_s, :title

end

# == Schema Information
#
# Table name: list_items
#
#  id          :integer          not null, primary key
#  title       :string
#  property_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ancestry    :string
#
