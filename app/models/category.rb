class Category < ActiveRecord::Base
  has_many :adverts, dependent: :destroy

  has_many :category_properties, dependent: :destroy
  has_many :properties, through: :category_properties
  has_many :old_properties, foreign_key: 'category_id', class_name: 'Property'

  validates_presence_of :title

  accepts_nested_attributes_for :properties

  has_ancestry cache_depth: true

  alias_attribute :to_s, :title

  scope :ordered, -> {order('title')}

  def all_properties
    properties = []
    catpro = category_properties.where(:show_on_public => :true)
    catpro.each do |cp|
      if ["limited_list", "unlimited_list", "hierarch_limited_list"].include? cp.property.kind
        properties << cp.property
      end
    end
    properties
  end
end

# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#
