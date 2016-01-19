class AddKindToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :kind, :string
  end
end
