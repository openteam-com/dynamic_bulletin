class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.string :title
      t.references :propertiable, polymorphic: true

      t.timestamps null: false
    end
  end
end
