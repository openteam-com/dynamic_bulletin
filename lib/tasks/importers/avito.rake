require 'progress_bar'

namespace :avito do
  desc 'store data from rest_app for avito'
  task adverts_parse: :environment do
    categories = [9, 10, 11, 14, 19, 20, 21, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 38, 39, 40, 42, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 96, 97, 98, 99, 101, 102, 105, 106, 111, 112, 114, 115, 116]
    bar = ProgressBar.new categories.size

    categories.each do |category_id|
      date_from = DateTime.new 2016, 03, 01

      43.times do
        RestAppParser.new(date_from: date_from.strftime('%Y-%m-%d'), category_id: category_id).parse!

        date_from += 1.day
      end

      bar.increment!
    end
  end

  desc 'apply avito data for our project'
  task adverts_import: :environment do
    bar = ProgressBar.new AvitoDatum.all.size
    AvitoDatum.find_each do |info|
      # info.rest_app_category_id
      # info.data - объявления
      categories_hash = ComparisonCategories.new(category_id: info.rest_app_category_id).search
      categories_hash = Hashie::Mash.new categories_hash.first
      self_category = Category.find(categories_hash.self_category_id)

      info['data'].each do |adv|
        advert = self_category.adverts.new(
          description: adv['description'],
          category_id: self_category.id
        )
        advert.save

        price = self_category.
          properties.
          where('title ilike ? OR title ilike ?', '%цена%', '%стоимость%').first

        price.values.create integer_value: adv['price'], advert_id: advert.id if price.present?
        if info.rest_app_category_id == 9
          # массив параметров автомобиля
          mark, model, volume, transmission, year, body_type = adv['title'].squish.split(' ')
          next if mark == 'Другая'
          mark_and_model = self_category.properties.where('title ilike ?', '%марка и модель%').first
          finded_mark = mark_and_model.hierarch_list_items.where('title ilike ?', "%#{mark}%").first
          finded_model = finded_mark.children.where('title ilike ?', "%#{model}%").first
          mark_and_model.values.create hierarch_list_item_id: finded_model.id, advert_id: advert.id if finded_model.present?
        end
      end

      bar.increment!
    end
  end
end
