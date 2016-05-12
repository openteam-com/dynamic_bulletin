class AddShowOnFilterAsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :show_on_filter_as, :string
  end
end
