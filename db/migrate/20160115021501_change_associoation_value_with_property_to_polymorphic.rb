class ChangeAssocioationValueWithPropertyToPolymorphic < ActiveRecord::Migration
  def up
    remove_column :values, :property_id
    add_column    :values, :propertiable_id, :integer
    add_column    :values, :propertiable_type, :string
  end

  def down
    add_column :values, :property_id, :string
    remove_column    :values, :propertiable_id
    remove_column    :values, :propertiable_type
  end
end
