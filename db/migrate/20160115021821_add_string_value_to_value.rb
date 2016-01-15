class AddStringValueToValue < ActiveRecord::Migration
  def change
    add_column :values, :string_value, :string
  end
end
