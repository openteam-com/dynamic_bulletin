class AddColumnsToPropertiesCategories < ActiveRecord::Migration
  def change
    add_column :category_properties, :show_on_public, :boolean, :default => true
    add_column :category_properties, :necessarily, :boolean, :default => false
    add_column :category_properties, :show_as, :string, :default => "check_boxes"

    Property.find_each do |property|
      property.category_properties.first.update_attributes(:show_as => property.show_as, :show_on_public => property.show_on_public, :necessarily => property.necessarily)
    end
  end
end
