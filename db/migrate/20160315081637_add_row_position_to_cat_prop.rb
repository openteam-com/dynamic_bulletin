class AddRowPositionToCatProp < ActiveRecord::Migration
  def change
    add_column :category_properties, :row_order, :integer
    remove_column :properties, :row_order, :integer
  end
end
