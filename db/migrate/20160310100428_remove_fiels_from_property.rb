class RemoveFielsFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :show_as
    remove_column :properties, :show_on_public
    remove_column :properties, :necessarily
  end
end
