class Property < ActiveRecord::Base
  belongs_to :category

  has_many :values, dependent: :destroy
  has_many :list_items, dependent: :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :list_items

  alias_attribute :to_s, :title

  extend Enumerize
  enumerize :kind, in: [:string, :limited_list, :unlimited_list]
end

# == Schema Information
#
# Table name: properties
#
#  id          :integer          not null, primary key
#  kind        :string
#  title       :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
