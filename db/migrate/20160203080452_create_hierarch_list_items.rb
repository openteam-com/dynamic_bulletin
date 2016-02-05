class CreateHierarchListItems < ActiveRecord::Migration
    def change
    create_table :hierarch_list_items do |t|
      t.string :title
      t.string :ancesrty
      t.references :property, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
