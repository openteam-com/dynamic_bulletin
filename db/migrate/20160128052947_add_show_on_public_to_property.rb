class AddShowOnPublicToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :show_on_public, :boolean, default: true
  end
end
