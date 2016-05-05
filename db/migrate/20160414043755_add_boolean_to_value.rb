class AddBooleanToValue < ActiveRecord::Migration
  def change
    add_column :values, :boolean_value, :boolean
  end
end
