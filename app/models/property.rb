class Property < ActiveRecord::Base
  extend Enumerize
  belongs_to :category
  validates_presence_of :title

  has_many :values, as: :propertiable

  has_many :list_items, as: :propertiable, dependent: :destroy
  accepts_nested_attributes_for :list_items

  alias_attribute :to_s, :title

  enumerize :kind, in: [:string, :limited_list]

  #def self.types
    ##self.subclasses.map(&:name)
    #['StringProperty', 'LimitedListProperty']
  #end

  def permitted_attributes
    []
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
#
