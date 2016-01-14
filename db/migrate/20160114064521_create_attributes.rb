class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string :type
      t.string :name
      t.references :category

      t.timestamps null: false
    end
  end
end
