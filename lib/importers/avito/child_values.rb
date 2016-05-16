module Avito
  class ChildValues
    attr_reader :advert

    def initialize(self_category, adv)
      categories_hash = Hashie::Mash.new collection
      case adv['params'][0]['value']
      when 'Для девочек'
        self_category = Category.find(adv['params'][1]['value'] == 'Обувь' ? categories_hash.girls.shoes : categories_hash.girls.clothes)
      when 'Для мальчиков'
        self_category = Category.find(adv['params'][1]['value'] == 'Обувь' ? categories_hash.boys.shoes : categories_hash.boys.clothes)
      end

      if adv['params'][2].present?
        arr = adv['params'][2]['value'].split.first.split('-').map(&:to_i)#размер одежды на авито
      end
      if arr.try(:size) == 2 && (self_category.parent.title == 'Детская одежда')
        arr = arr[0]..arr[1]
        arr = arr.to_a
        self_category = Category.find(categories_hash.newborns) if arr[0] < 92
        finded_age = nil
        max = 0
        property = self_category.properties.where('title ilike ?', '%возраст%').first
        property.list_items.each do |list_item|
          arr2 = list_item.title.split[-2]#размер одежды на доске
          arr2 = arr2.slice(1, arr2.size).split('-').map(&:to_i)
          arr2 = arr2[0]..arr2[1]
          arr2 = arr2.to_a
          mult_arr =  arr & arr2
          if mult_arr.size > max
            max = mult_arr.size
            finded_age = list_item
          end
        end
      end
      @advert = self_category.adverts.new(description: adv['description'])
      advert.save

      if adv["params"][1]["value"] == "Обувь"
        property = self_category.properties.where('title ilike ?', "%размер%").first
        size = property.list_items.where('title ilike ?', "%#{adv["params"][2].try(:[],"value")}%").first
        property.values.create list_item_ids: size.id, advert_id: advert.id if size.present?
      else
        property = self_category.properties.where('title ilike ?', "%возраст%").first
        if self_category.title != "Для новорожденных"
          property.values.create list_item_id: finded_age.id, advert_id: advert.id if !finded_age.nil?
          property = self_category.properties.where('title ilike ?', "%предмет одежды%").first
          type = property.list_items.where('title ilike ?', "%#{adv["params"][1]["value"]}%").first
          property.values.create list_item_id: type.id, advert_id: advert.id if type.present?
        else
          property.values.create list_item_ids: finded_age.id, advert_id: advert.id if !finded_age.nil?
        end
      end

      season = nil
      desc_adv = adv['description'].mb_chars.downcase.to_s
      title_adv = adv['title'].mb_chars.downcase.to_s
      property = self_category.properties.where('title ilike ?', "%по сезону%").first
      if desc_or_title_inc?(desc_adv, title_adv, ["зим"])
        season = property.list_items.where(:title => "Зимняя").first
      elsif desc_or_title_inc?(desc_adv, title_adv, ["демисез", "д/с", "весна-осень", "осень-весна"])
        season = property.list_items.where(:title => "Демисезонная").first
      elsif desc_or_title_inc?(desc_adv, title_adv, ["летн", "лето"])
        season = property.list_items.where(:title => "Лентняя и домашняя").first
      end
      property.values.create list_item_id: season.id, advert_id: advert.id if !season.nil?
    end

    def return_advert
      advert
    end

    def desc_or_title_inc?(d, t, arr)
      arr.each do |sub|
        if !d[sub].nil? || !t[sub].nil?
          return true
        end
      end
      false
    end

    def collection
      {
        rest_app_category_id: 29,
        root_category_id: 5,
        self_category_id: 6,
        girls: {shoes: 19, clothes: 16},
        boys: {shoes: 18, clothes: 15},
        newborns: 17
      }
    end
  end
end
