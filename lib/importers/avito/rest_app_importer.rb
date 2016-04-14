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
      puts "#{mark} #{model} 1"

      #next if mark == 'Другая'
      unless mark == 'Другая'
        mark_and_model = self_category.properties.where('title ilike ?', '%марка и модель%').first
        finded_mark = mark_and_model.hierarch_list_items.where('title ilike ?', "%#{mark}%").first
        finded_model = finded_mark.children.where('title ilike ?', "%#{model}%").first
        p "#{finded_mark} #{finded_model} 2"
        mark_and_model.values.create hierarch_list_item_id: finded_model.id, advert_id: advert.id if finded_model.present?
      end
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
