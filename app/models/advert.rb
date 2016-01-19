class Advert < ActiveRecord::Base
  belongs_to :category
  has_many :values, dependent: :destroy

  accepts_nested_attributes_for :values

  after_initialize :build_empty_values

  def title
    values.first.value
  end

  private
  def build_empty_values
    return unless category
    category.properties.each do |property|
      values << property.values.new unless values.select {|v| v.property == property}.any?
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
