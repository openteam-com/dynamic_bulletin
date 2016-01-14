class DropStringProperty < ActiveRecord::Migration
  def up
    drop_table :string_properties
  end
  def down
    create_table :string_properties do |t|
      t.integer :max_length

      t.timestamps null: false
    end
  end
end
