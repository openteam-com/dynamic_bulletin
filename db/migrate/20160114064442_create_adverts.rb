class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.text :description
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
