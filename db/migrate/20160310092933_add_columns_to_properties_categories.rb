class AddColumnsToPropertiesCategories < ActiveRecord::Migration
  def change
    add_column :category_properties, :show_on_public, :boolean, :default => true
    add_column :category_properties, :necessarily, :boolean, :default => false
    add_column :category_properties, :show_as, :string, :default => "check_boxes"
  end
end
