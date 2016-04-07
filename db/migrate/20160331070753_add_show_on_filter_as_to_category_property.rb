class AddShowOnFilterAsToCategoryProperty < ActiveRecord::Migration
  def change
    add_column :category_properties, :show_on_filter_as, :string
  end
end
