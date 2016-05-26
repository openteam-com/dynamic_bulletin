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

module CategoriesHelper
  def min_value(property)
    property.list_items.map(&:title).map(&:to_i).delete_if {|x| x == 0}.min
  end
  def max_value(property)
    property.list_items.map(&:title).map(&:to_i).max
  end
  def ticks_value(property)
    property.list_items.map(&:title).map(&:to_i).delete_if{|x| x == 0}.sort.each_slice(property.list_items.count/4).map(&:first)
  end
  def value(property_id, params_properties)
    if !params_properties.nil?
      params_properties.find {|p| p[0].to_i == property_id}[1].split(',').map(&:to_i)
    else
      property = Property.find(property_id)
      return [min_value(property),max_value(property)]
    end
  end
end
