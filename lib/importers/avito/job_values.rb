module Avito
  class JobValues
    attr_reader :advert
    def initialize(self_category, adv)
      #график работы, тип занятости, стаж
      type_activity = adv['params'].find {|i| i['name'] == 'Сфера деятельности'}['value']
      case type_activity
      when 'Административная работа'
        type_activity = 'Высший менеджмент, руководители'
      when 'Госслужба, НКО'
        type_activity = 'Государственные службы, НКО'
      when 'Управление персоналом'
        type_activity = 'Высший менеджмент, руководители'
      when 'Транспорт, логистика'
        type_activity = 'Логистика'
      when 'IT, интернет, телеком'
        type_activity = 'ИТ и Интернет'
      when 'Туризм, рестораны'
        type_activity = 'Рестораны'
      when 'Производство, сырьё, с/х'
        type_activity = 'Сельское хозяйство'
      when 'Консультирование'
        type_activity = 'Сфера услуг'
      when 'Автомобильный бизнес'
        type_activity = 'Транспорт'
      when 'Фитнес, салоны красоты'
        type_activity = 'Спорт, красота, здоровье'
      when 'Без опыта, студенты'
        type_activity = 'Рабочий персонал'
      when 'ЖКХ, эксплуатация'
        type_activity = 'Государственные службы'
      when 'Банки, инвестиции'
        type_activity = 'Банки'
      end
      self_category = self_category.children.where('title ilike ?', "%#{type_activity}%").first

      @advert = self_category.adverts.new(description: adv['description'])
      advert.save

      property = self_category.properties.where('title ilike ?', "%график%").first
      finded_graphic = property.list_items.where("title ilike ?", "%#{adv["params"][1]["value"].split[0]}%").first
      property.values.create list_item_ids: finded_graphic.id, advert_id: advert.id if !finded_graphic.nil?

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
    def return_advert
      advert
    end
  end
end
