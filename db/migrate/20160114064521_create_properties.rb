class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :type
      t.string :name
      t.references :category

      t.timestamps null: false
    end
  end
end
