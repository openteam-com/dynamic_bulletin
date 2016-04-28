class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.timestamps null: false
    end
    add_column :images, :advert_id, :integer
    add_foreign_key :images, :adverts
  end
end
