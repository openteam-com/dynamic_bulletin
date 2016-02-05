class AddHierarchListItemIdToValue < ActiveRecord::Migration
  def change
    add_column :values, :hierarch_list_item_id, :integer
  end
end
