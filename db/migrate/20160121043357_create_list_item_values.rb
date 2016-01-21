class CreateListItemValues < ActiveRecord::Migration
  def change
    create_table :list_item_values do |t|
      t.integer :list_item_id
      t.integer :value_id
    end
  end
end
