class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.references :advert, index: true, foreign_key: true
      t.references :property, index: true, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
  end
end
