class AddFloatValueToValue < ActiveRecord::Migration
  def change
    add_column :values, :float_value, :float
  end
end
