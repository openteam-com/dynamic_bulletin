class AddColumnToValue < ActiveRecord::Migration
  def change
    add_column :values, :integer_value, :integer
  end
end
