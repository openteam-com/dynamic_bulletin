module Metadata::PropertiesHelper
  def can_change_property_fields?(category, property)
    category.is_root? || property.new_record? || CategoryProperty.where(:property_id => property.id).sort.first.category == category
  end
end
