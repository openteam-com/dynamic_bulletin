class CreateAvitoData < ActiveRecord::Migration
  def change
    create_table :avito_data do |t|
      t.text :data
      t.integer :rest_app_category_id

      t.timestamps null: false
    end
  end
end
