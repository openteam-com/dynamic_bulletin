module Avito
  class ClothesValues
    def initialize(self_category, adv, advert)
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
            property.values.create list_item_id: find_size.id, advert_id: advert.id
          else
            property.values.create list_item_ids: find_size.id, advert_id: advert.id
          end
        end
        property = self_category.properties.where('title ilike ?', "%предмет%").first
        adv["params"][1]["value"] = "Футболки" if adv["params"][1]["value"] == "Трикотаж и футболки"
        find_value = property.list_items.where('title ilike ?', "%#{adv["params"][1]["value"]}%").first
        if self_category.title == "Для мужчин"
          property.values.create list_item_id: find_value.id, advert_id: advert.id
        else
          property.values.create list_item_ids: find_value.id, advert_id: advert.id
        end
      elsif self_category.parent.title == "Обувь"
        property = self_category.properties.where('title ilike ?', "%размер%").first
        find_value = property.list_items.where('title ilike ?', "%#{adv["params"][2]["value"]}%").first
        property.values.create list_item_id:  find_value.id, advert_id: advert.id
      end
    end
  end


end
