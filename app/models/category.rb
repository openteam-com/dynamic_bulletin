class Category < ActiveRecord::Base
  belongs_to :link, foreign_key: 'connect_with_id', class_name: 'Category'

  has_many :links, foreign_key: 'connect_with_id', class_name: 'Category'
  has_many :adverts, dependent: :destroy
  has_many :category_properties, dependent: :destroy
  has_many :properties, through: :category_properties
  has_many :old_properties, foreign_key: 'category_id', class_name: 'Property'

  validates_presence_of :title

  accepts_nested_attributes_for :properties

  has_ancestry cache_depth: true

  alias_attribute :to_s, :title

  scope :ordered, -> {order('title')}
  scope :not_connected, -> {where(:connect_with_id == nil)}
  scope :connected, -> {where(:connect_with_id != nil)}

  def all_properties
    [].tap do |array|
      properties.each do |property|
        if ["limited_list", "unlimited_list", "hierarch_limited_list"].include? property.kind
          array << property
        end
      end
    end
  end

  def inserted
    links.flatten + children.flatten
  end
end

# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ancestry        :string
#  ancestry_depth  :integer          default(0)
#  connect_with_id :integer
#
