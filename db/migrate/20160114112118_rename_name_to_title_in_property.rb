class RenameNameToTitleInProperty < ActiveRecord::Migration
  def change
    rename_column :properties, :name, :title
  end
end
