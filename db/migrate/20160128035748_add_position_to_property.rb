class AddPositionToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :row_order, :integer
  end
end
