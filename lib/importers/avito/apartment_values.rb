module Avito
  class ApartmentValues
    def initialize(self_category, adv, advert)
      title_parse = adv['title'].split(',')
      if ["Вторичка ", "Новостройка", "На длительный срок", "Посуточно"].include? self_category.title #пробел во вторичке
        property = self_category.properties.where(:title => "Тип дома").first
        find_type = property.list_items.where('title ilike ?', "%#{adv["params"].find {|i| i["name"] == "Тип дома"}["value"]}%").first if !property.nil?
        property.values.create list_item_ids: find_type.id, advert_id: advert.id if !find_type.nil?
        if title_parse.count > 1
          area = title_parse[1].split[0].to_f
          floor, all_floor = title_parse[2].split[0].split('/')

          property = self_category.properties.where(:title => "Площадь").first
          property.values.create float_value: area, advert_id: advert.id

          property = self_category.properties.where(:title => "Этаж").first
          find_value = property.list_items.where('title ilike ?', "%#{floor}%").first
          property.values.create list_item_id: find_value.id, advert_id: advert.id

          property = self_category.properties.where(:title => "Этажей в доме").first
          find_value = property.list_items.where('title ilike ?', "%#{all_floor}%").first
          property.values.create list_item_id: find_value.id, advert_id: advert.id
        end
      end
      rooms = title_parse[0].split[0].split('-')[0] if title_parse.count > 1
      property = self_category.properties.where(:title => "Количество комнат").first
      if rooms.to_i != 0
        find_value = property.list_items.where('title ilike ?', "%#{rooms}%").first
      elsif rooms.to_i > 9
        find_value = property.list_items.where(:title => '> 9').first
      elsif !adv['title'].mb_chars.downcase.to_s["студи"].nil?
        find_value = property.list_items.where(:title => 'Студия').first
      else
        rooms = adv['title'].split.find {|i| i["-к"]}.split('-')[0]
        find_value = property.list_items.where('title ilike ?', "%#{rooms}%").first
      end
      property.values.create list_item_id: find_value.id, advert_id: advert.id if !find_value.nil?
    end
  end
end
