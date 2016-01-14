class Property < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title

  alias_attribute :to_s, :title

  def self.types
    #self.subclasses.map(&:name)
    ['StringProperty']
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
