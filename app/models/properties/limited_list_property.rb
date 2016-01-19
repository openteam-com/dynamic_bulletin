# == Schema Information
#
# Table name: properties
#
#  id          :integer          not null, primary key
#  type        :string
#  title       :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  max_length  :integer
#

class LimitedListProperty < Property
  has_many :list_items, as: :propertiable, dependent: :destroy

  accepts_nested_attributes_for :list_items

  def permitted_attributes
    %W(list_item_id)
  end
end
