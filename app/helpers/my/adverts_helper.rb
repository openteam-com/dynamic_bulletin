module My::AdvertsHelper
  def property_show_as(value, category_id)
    CategoryProperty.find_by(category_id: category_id, property_id: value.property).show_as.to_sym
  end
end
