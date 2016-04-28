class Advert < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :values, dependent: :delete_all
  accepts_nested_attributes_for :values

  after_initialize :build_empty_values, if: :new_record?

  alias_attribute :to_s, :title

  def title
    description
  end

  private
  def build_empty_values
    return unless category

    category.properties.each do |property|
      values << property.values.new unless values.select {|v| v.property == property}.any?
    end
  end

  searchable include: [:values] do
    integer :list_item_ids, multiple: true do
      values.map { |v| v.list_items.map(&:id) + values.map(&:list_item).compact.map(&:id) }.flatten.compact.uniq
    end

    integer :hierarch_list_item_ids, multiple: true do
      values.map(&:hierarch_list_item).compact.map(&:id)
    end

    integer(:category_id) { category.id }
  end
end

# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  description :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
