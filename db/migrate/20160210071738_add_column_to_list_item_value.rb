class AddColumnToListItemValue < ActiveRecord::Migration
  def change
    add_column :list_item_values, :hierarch_list_item_id, :integer
  end
end
