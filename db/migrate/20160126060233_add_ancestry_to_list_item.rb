class AddAncestryToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :ancestry, :string
    add_index :list_items, :ancestry
  end
end
