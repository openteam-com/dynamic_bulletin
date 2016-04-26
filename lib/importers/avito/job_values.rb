module Avito
  class JobValues
    def initialize(self_category, adv, advert)
     #график работы, тип занятости, стаж
      property = self_category.properties.where('title ilike ?', "%график%").first
      finded_graphic = property.list_items.where("title ilike ?", "%#{adv["params"][1]["value"].split[0]}%").first
      property.values.create list_item_ids: finded_graphic.id, advert_id: advert.id if !finded_graphic.nil?

      puts advert
      if adv["params"][1]["value"] == "Вахтовый метод"
        property = self_category.properties.where('title ilike ?', "%тип занятости%").first
        finded_type = property.list_items.where('title ilike ?', "%вахтов%").first
        property.values.create list_item_ids: finded_type.id, advert_id: advert.id
      end

      case adv["params"][2]["value"]
      when "Не имеет значения"
        adv["params"][2]["value"] = "Без опыта"
      when "Более 1 года"
        adv["params"][2]["value"] = "1-3 года"
      when "Более 3 лет"
        adv["params"][2]["value"] = "3-5 лет"
      end

      property = self_category.properties.where('title ilike ?', "%стаж%").first
      finded_stage = property.list_items.where("title ilike ?", "%#{adv["params"][2]["value"]}%").first
      property.values.create list_item_id: finded_stage.id, advert_id: advert.id if !finded_stage.nil?
    end
  end
end
