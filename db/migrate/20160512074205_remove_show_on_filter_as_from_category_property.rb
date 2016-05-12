class RemoveShowOnFilterAsFromCategoryProperty < ActiveRecord::Migration
  def change
    remove_column :category_properties, :show_on_filter_as
  end
end
