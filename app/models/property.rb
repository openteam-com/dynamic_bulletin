class Property < ActiveRecord::Base
  extend Enumerize
  belongs_to :category
  validates_presence_of :title

  has_many :values, dependent: :destroy

  has_many :list_items, dependent: :destroy
  accepts_nested_attributes_for :list_items

  alias_attribute :to_s, :title

  enumerize :kind, in: [:string, :limited_list]

  def permitted_attributes
    case kind.to_sym
    when :string
      ['string_value']
    when :limited_list
      ['list_item_id']
    else
      []
    end
  end


end

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
#  kind        :string
#
