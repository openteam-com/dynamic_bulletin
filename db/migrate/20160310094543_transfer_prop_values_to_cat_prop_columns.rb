class TransferPropValuesToCatPropColumns < ActiveRecord::Migration
  def change
    Property.find_each do |property|
      property.category_properties.first.update_attributes(:show_as => property.show_as, :show_on_public => property.show_on_public, :necessarily => property.necessarily)
    end
  end
end
