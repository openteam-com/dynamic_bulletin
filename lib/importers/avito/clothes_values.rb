module Avito
  class ClothesValues
    attr_reader :advert

    def initialize(self_category, adv)
      categories_hash = Hashie::Mash.new collection
      if adv['params'][0]['value'] == 'Аксессуары'
        self_category = Category.find(categories_hash.accessories.other) #'Другие' из данных нельзя узнать какие именно аксессуары
      elsif adv['params'][0]['value'] == 'Женская одежда'
        self_category = Category.find(adv['params'][1]['value'] == 'Обувь' ? categories_hash.woman.shoes : categories_hash.woman.clothes)
      else
        self_category = Category.find(adv['params'][1]['value'] == 'Обувь' ? categories_hash.man.shoes : categories_hash.man.clothes)
      end

      @advert = self_category.adverts.new(description: adv['description'])
      advert.save

      if self_category.parent.title == "Одежда"
        if !adv["params"][2].nil? && adv["params"][2]["name"] == "Размер"
          property = self_category.properties.where('title ilike ?', "%размер%").first
          size = adv["params"][2]["value"].split[0].split("–")
          if size.count == 2
            size = size[0] + "-" + size[1]
          else
            size = "Без размера"
          end
          find_size = property.list_items.where('title ilike ?', "%#{size}%").first
          if self_category.title == "Для мужчин"
            property.values.create list_item_id: find_size.id, advert_id: advert.id if !find_size.nil?
          else
            property.values.create list_item_ids: find_size.id, advert_id: advert.id if !find_size.nil?
          end
        end
        property = self_category.properties.where('title ilike ?', "%предмет%").first
        adv["params"][1]["value"] = "Футболки" if adv["params"][1]["value"] == "Трикотаж и футболки"
        adv["params"][1]["value"] = "Нижнее белье" if adv["params"][1]["value"] == "Нижнее бельё"
        find_value = property.list_items.where('title ilike ?', "%#{adv["params"][1]["value"]}%").first
        if self_category.title == "Для мужчин"
          property.values.create list_item_id: find_value.id, advert_id: advert.id if !find_value.nil?
        else
          property.values.create list_item_ids: find_value.id, advert_id: advert.id if !find_value.nil?
        end
      elsif self_category.parent.title == "Обувь"
        property = self_category.properties.where('title ilike ?', "%размер%").first
        find_value = property.list_items.where('title ilike ?', "%#{adv["params"][2]["value"]}%").first
        property.values.create list_item_id:  find_value.id, advert_id: advert.id if !find_value.nil?
      end
    end

    def return_advert
      advert
    end

    def collection
      {
        rest_app_category_id: 27,
        root_category_id: 35,
        self_category_id: 35,
        accessories: {other: 534},
        woman: {shoes: 40, clothes: 38},
        man: {shoes: 41, clothes: 530}
      }
    end
  end
end
