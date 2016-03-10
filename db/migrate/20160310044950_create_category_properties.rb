class CreateCategoryProperties < ActiveRecord::Migration
  def change
    create_table :category_properties do |t|
      t.references :category
      t.references :property

      t.timestamps false
    end

    Category.roots.each do |root|
      root.descendants.each do |child|
        child.old_properties.each do |property|
          unless root.old_properties.map(&:title).include?(property.title)
            root.old_properties << property
          else
            property.destroy
          end
        end
      end
    end

    Property.find_each do |property|
      property.category_properties.create! property_id: property.id, category_id: property.category_id
    end
  end
end
