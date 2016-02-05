class RenameColumnFromHierarchListItems < ActiveRecord::Migration
  def change
	rename_column :hierarch_list_items, :ancesrty, :ancestry
  end
end
