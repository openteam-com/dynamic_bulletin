class Category < ActiveRecord::Base
  attr_accessor :properties_types

  has_many :adverts
  has_many :properties
  validates_presence_of :title

  accepts_nested_attributes_for :properties

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
#
