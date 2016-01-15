class Advert < ActiveRecord::Base
  belongs_to :category
  has_many :values, dependent: :destroy

  accepts_nested_attributes_for :values

  after_initialize :build_values

  private
  def build_values
    return unless category
    category.properties.each do |property|
raise property.values.build.inspect
      values << "#{property.class.name}Value".constantize.new(:propertiable => property)
    end
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
#
