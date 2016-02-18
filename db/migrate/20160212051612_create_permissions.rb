class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :role
      t.integer :user_id
    end
  end
end
