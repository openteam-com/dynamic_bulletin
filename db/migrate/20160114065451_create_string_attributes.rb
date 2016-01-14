class CreateStringAttributes < ActiveRecord::Migration
  def change
    create_table :string_attributes do |t|
      t.integer :max_length

      t.timestamps null: false
    end
  end
end
