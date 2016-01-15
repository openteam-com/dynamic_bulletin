class Property < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title

  has_many :values, as: :propertiable

  alias_attribute :to_s, :title

  def self.types
    #self.subclasses.map(&:name)
    ['StringProperty']
  end

  def permitted_attributes
    []
  end


end

# == Schema Information
#
# Table name: attributes
#
#  id          :integer          not null, primary key
#  type        :string
#  name        :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
