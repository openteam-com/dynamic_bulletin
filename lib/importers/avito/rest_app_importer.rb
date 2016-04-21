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
          advert = self_category.adverts.new(description: adv['description'])
          advert.save

          price = self_category.
            properties.
            where('title ilike ? OR title ilike ?', '%цена%', '%стоимость%').first

          price.values.create integer_value: adv['price'], advert_id: advert.id if price.present?

          if info.rest_app_category_id == 9
            CarValues.new(self_category, adv, advert)
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
        }
      ]
    end
  end
end
