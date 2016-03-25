class AddConnectWithToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :connect_with_id, :integer
  end
end
