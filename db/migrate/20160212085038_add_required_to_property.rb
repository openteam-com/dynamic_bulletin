class AddRequiredToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :necessarily, :boolean, default: false
  end
end
