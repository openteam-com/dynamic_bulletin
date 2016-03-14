class RemoveCategoryFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :category_id
  end
end
