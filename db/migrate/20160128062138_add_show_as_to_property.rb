class AddShowAsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :show_as, :string, default: 'check_boxes'
  end
end
