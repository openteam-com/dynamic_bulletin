module Avito
  class CarValues
    def initialize(self_category, adv, advert)
      # массив параметров автомобиля
      mark, model, volume, transmission, year, body_type = adv['title'].squish.split(' ')

      mark_and_model = self_category.properties.where('title ilike ?', '%марка и модель%').first
      if volume.to_f == 0.0
        m1, m2, m3, volume, transmission, year, body_type = adv['title'].squish.split(' ')
        finded_mark = mark_and_model.hierarch_list_items.where('title ilike ?', "%#{m1}%").first
        if finded_mark.present?
          mark = m1
          model = m2 + ' ' +  m3
        else
          mark = m1 + ' ' + m2
          model = m3
        end
      end
      unless mark == 'Другая'
        finded_mark = mark_and_model.hierarch_list_items.where('title ilike ?', "%#{mark}%").first
        finded_model = finded_mark.children.where('title ilike ?', "%#{model}%").first
        mark_and_model.values.create hierarch_list_item_id: finded_model.id, advert_id: advert.id if finded_model.present?
      end
      create_list_item("объем", volume, self_category, advert)
      create_list_item("коробка передач", transmission, self_category, advert)
      create_list_item("год выпуска", year, self_category, advert)
      create_list_item("тип кузова", body_type, self_category, advert)
      create_list_item("пробег", adv["params"].find{|p| p["name"] == "Пробег, км"}.try(:[], "value"), self_category, advert)
      create_list_item("цвет", adv["params"].find{|p| p["name"] == "Цвет"}["value"], self_category, advert)
      create_list_item("Количество дверей", adv["params"].find{|p| p["name"] == "Количество дверей"}.try(:[], "value"), self_category, advert)
      create_list_item("вид топлива", adv["params"].find{|p| p["name"] == "Тип двигателя"}["value"], self_category, advert)
      create_list_item("привод",adv["params"].find{|p| p["name"] == "Привод"}["value"] , self_category, advert)
      create_list_item("руль", adv["params"].find{|p| p["name"] == "Руль"}["value"], self_category, advert)

      property = self_category.properties.where('title ilike ?', "%мощность двигателя%").first
      property.values.create integer_value: adv["params"].find{|p| p["name"] == "Мощность двигателя, л.с."}["value"].to_i, advert_id: advert.id

    end

    def create_list_item(name_property, value, self_category, advert)
      property = self_category.properties.where('title ilike ?', "%#{name_property}%").first
      finded_value = property.list_items.where('title ilike ?', "%#{value}%").first
      property.values.create list_item_id: finded_value.id, advert_id: advert.id if finded_value.present?
    end
  end
end
