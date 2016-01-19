class Advert < ActiveRecord::Base
  attr_accessor :values_attributes
  belongs_to :category
  has_many :values, dependent: :destroy

  accepts_nested_attributes_for :values, reject_if: proc {false}

  after_initialize :build_values, :if => :new_record?

  def title
    values.first.value
  end

  private
  def build_values
    return unless category
    category.properties.each do |property|
      values << property.values.new((prepare_values_attributes[property.id] || {} ).extract!(*property.permitted_attributes)
      )
    end
  end

  def prepare_values_attributes
    @prepare_values_attributes ||= {}.tap do |hash|
      (values_attributes || {}).values.each do |value_attributes|
        hash[value_attributes.delete('property_id').to_i] = value_attributes
      end
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
