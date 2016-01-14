class CreateStringProperties < ActiveRecord::Migration
  def change
    create_table :string_properties do |t|
      t.integer :max_length

      t.timestamps null: false
    end
  end
end
