module Avito
  class RestAppImporter
    def parse
      bar = ProgressBar.new AvitoDatum.all.size
      AvitoDatum.find_each do |info|
        # info.rest_app_category_id
        # info.data - объявления
        categories_hash = ComparisonCategories.new(category_id: info.rest_app_category_id).search
        categories_hash = Hashie::Mash.new categories_hash.first
        self_category = Category.find(categories_hash.self_category_id)

        info['data'].each do |adv|

          if info.rest_app_category_id == 29
            case adv["params"][0]["value"]
            when "Для девочек"
              self_category = Category.find(adv["params"][1]["value"] == "Обувь" ? 19 : 16)
            when "Для мальчиков"
              self_category = Category.find(adv["params"][1]["value"] == "Обувь" ? 18 : 15)
            end
            if adv["params"][2].present?
              arr = adv["params"][2]["value"].split.first.split('-').map(&:to_i)#размер одежды на авито
            end
            if arr.try(:size) == 2 && (self_category.id == 16 || self_category.id == 15)
              arr = arr[0]..arr[1]
              arr = arr.to_a
              self_category = Category.find(17) if arr[0] < 92
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
          end

          advert = self_category.adverts.new(description: adv['description'])
          advert.save

          price = self_category.
            properties.
            where('title ilike ? OR title ilike ?', '%цена%', '%стоимость%').first
          price.values.create integer_value: adv['price'], advert_id: advert.id if price.present?

          if info.rest_app_category_id == 9
            CarValues.new(self_category, adv, advert)
          end
          if info.rest_app_category_id == 29
            ChildValues.new(self_category, adv, advert, finded_age)
          end
        end
        bar.increment!
      end
    end
  end

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

  class ChildValues
    def initialize(self_category, adv, advert, finded_age)
      if adv["params"][1]["value"] == "Обувь"
        property = self_category.properties.where('title ilike ?', "%размер%").first
        size = property.list_items.where('title ilike ?', "%#{adv["params"][2].try(:[],"value")}%").first
        property.values.create list_item_ids: size.id, advert_id: advert.id if size.present?
      else
        property = self_category.properties.where('title ilike ?', "%возраст%").first
        if self_category.id != 17#не новорожденные
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

    def desc_or_title_inc?(d, t, arr)
      arr.each do |sub|
        if !d[sub].nil? || !t[sub].nil?
          return true
        end
      end
      false
    end
  end

  class ComparisonCategories
    attr_reader :rest_app_category

    def initialize(params = {})
      @rest_app_category = params[:category_id]
    end

    def search
      collection.select { |hash| hash if hash[:rest_app_category_id] == rest_app_category }
    end

    private
    def collection
      [
        {
          rest_app_category_id: 9,
          root_category_id: 304,
          self_category_id: 305
        },
        {

        },
        {
          rest_app_category_id: 24,
          root_category_id: 338,
          self_category_id: 339
        },
        {
          rest_app_category_id: 29,
          root_category_id: 5,
          self_category_id: 6
        }
      ]
    end
  end
end
