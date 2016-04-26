module Avito
  class ResumeValues
    def initialize(self_category, adv, advert)
      property = self_category.properties.where('title ilike ?', "%график%").first
      graphic = adv["params"].find {|i| i["name"] == "График работы"}["value"].split[0]
      finded_graphic = property.list_items.where("title ilike ?", "%#{graphic}%").first if !property.nil?
      property.values.create list_item_ids: finded_graphic.id, advert_id: advert.id if !finded_graphic.nil?

      stage = adv["params"].find {|i| i["name"] == "Опыт работы, лет"}["value"].to_i
      case stage
      when 0
        stage = "Без опыта"
      when 1 .. 2
        stage = "1-3 года"
      when 3 .. 5
        stage = "3-5 лет"
      when 6 .. 100
        stage = "Более 5 лет"
      end
      property = self_category.properties.where('title ilike ?', "%стаж%").first
      finded_stage = property.list_items.where("title ilike ?", "%#{stage}%").first if !property.nil?
      property.values.create list_item_id: finded_stage.id, advert_id: advert.id if !finded_stage.nil?
    end
  end
end
