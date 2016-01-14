class AddMaxLengthToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :max_length, :integer
  end
end
