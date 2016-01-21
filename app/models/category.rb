class Category < ActiveRecord::Base
  has_many :adverts, dependent: :destroy
  has_many :properties, dependent: :destroy

  validates_presence_of :title

  accepts_nested_attributes_for :properties

  has_ancestry

  alias_attribute :to_s, :title

  scope :ordered, -> {order('title')}
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string
#
