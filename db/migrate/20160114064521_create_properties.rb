class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :kind
      t.string :title
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
