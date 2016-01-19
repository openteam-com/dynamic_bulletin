class AssociateListItemWithValue < ActiveRecord::Migration
  def change
    add_reference :values, :list_item, index: true
  end
end
