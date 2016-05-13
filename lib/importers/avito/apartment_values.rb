module Avito
  class ApartmentValues
    attr_reader :advert

    def initialize(self_category, adv)
      categories_hash = collection
      categories_hash = Hashie::Mash.new categories_hash
      case adv['params'][0]['value']
      when 'Продам'
        self_category = Category.find(adv['params'][1]['value'] == 'Вторичка' ? categories_hash.selling.resale : categories_hash.selling.new_building)
      when 'Сдам'
        self_category = Category.find(adv['params'][1]['value'] == 'Посуточно' ? categories_hash.for_rent.daily : categories_hash.for_rent.for_a_long_time)
      when 'Куплю'
        self_category = Category.find(categories_hash.buy.resale)
      when 'Сниму'
        self_category = Category.find(adv['params'][1]['value'] == 'Посуточно' ? categories_hash.take_off.daily : categories_hash.take_off.for_a_long_time)
      end
      @advert = self_category.adverts.new(description: adv['description'])
      advert.save

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

    def return_advert
      advert
    end

    def collection
      {
        rest_app_category_id: 24,
        root_category_id: 338,
        self_category_id: 339,
        selling: {resale: 344, new_building: 345},
        for_rent: {daily: 347, for_a_long_time: 346},
        buy: {resale: 348, new_building: 349},
        take_off: {daily: 351, for_a_long_time: 350}
      }
    end
  end
end
