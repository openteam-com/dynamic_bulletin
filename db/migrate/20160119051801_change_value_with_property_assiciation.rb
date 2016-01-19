class ChangeValueWithPropertyAssiciation < ActiveRecord::Migration
  def up
    add_column :values, :property_id, :string
    remove_column    :values, :propertiable_id
    remove_column    :values, :propertiable_type
  end

  def down
    remove_column :values, :property_id
    add_column    :values, :propertiable_id, :integer
    add_column    :values, :propertiable_type, :string
  end

end
