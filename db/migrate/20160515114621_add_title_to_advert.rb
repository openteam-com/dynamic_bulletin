class AddTitleToAdvert < ActiveRecord::Migration
  def change
    add_column :adverts, :title, :string
  end
end
