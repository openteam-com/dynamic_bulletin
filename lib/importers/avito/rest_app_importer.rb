require 'open-uri'

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
          case info.rest_app_category_id #поиск вложенной категории - вынести?
          when 29
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
          when 24
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
          when 27
            if adv['params'][0]['value'] == 'Аксессуары'
              self_category = Category.find(categories_hash.accessories.other) #'Другие' из данных нельзя узнать какие именно аксессуары
            elsif adv['params'][0]['value'] == 'Женская одежда'
              self_category = Category.find(adv['params'][1]['value'] == 'Обувь' ? categories_hash.woman.shoes : categories_hash.woman.clothes)
            else
              self_category = Category.find(adv['params'][1]['value'] == 'Обувь' ? categories_hash.man.shoes : categories_hash.man.clothes)
            end
          when 114, 115
            self_category.children.each do |category|
              title_self = adv['params'][0]['value'].gsub('ё','е')
              title_finded = category.title.gsub('ё', 'е')
              if title_finded.split(' и ').count > 1
                title_finded = title_finded.split(' и ').map(&:strip)
                title_finded = title_finded[0] + ' ' + title_finded[1]
              elsif title_finded.split(',').count > 1
                title_finded = title_finded.split(',').map(&:strip)
                title_finded = title_finded[0] + ' ' + title_finded[1]
              end
              title_finded = title_finded.mb_chars.downcase.to_s.strip
              if title_self.split(' и ').count > 1
                title_self = title_self.split(' и ').map(&:strip)
                title_self = title_self[0] + ' ' + title_self[1]
              elsif title_self.split(',').count > 1
                title_self = title_self.split(',').map(&:strip)
                title_self = title_self[0] + ' ' + title_self[1]
              end
              title_self = title_self.mb_chars.downcase.to_s.strip
              if (title_self <=> title_finded) == 0
                self_category = category
                break
              end
            end
          when 111, 112
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
          end

          advert = self_category.adverts.new(description: adv['description'])
          advert.save

          price = self_category.
            properties.
            where('title ilike ? OR title ilike ? OR title ilike ?', '%цена%', '%стоимость%', '%плата%').first
          price.values.create integer_value: adv['price'], advert_id: advert.id if price.present?

          adv['images'].split(',').map(&:strip).each do |url|
            extname = File.extname(url)
            next if extname != '.jpg'
            basename = File.basename(url, extname)
            file = Tempfile.new([basename, extname])
            file.binmode

            begin
              open(URI.parse(url)) do |data|
                file.write data.read
              end
            rescue OpenURI::HTTPError => ex
              puts ex.inspect
            end

            image = advert.images.new
            image.image = file
            image.save
          end

          case info.rest_app_category_id
          when 9
            CarValues.new(self_category, adv, advert)
          when 29
            ChildValues.new(self_category, adv, advert, finded_age)
          when 24
            ApartmentValues.new(self_category, adv, advert)
          when 27
            ClothesValues.new(self_category, adv, advert)
          when 114, 115
            self_category = Category.find(categories_hash.self_category_id)
          when 111
            JobValues.new(self_category, adv, advert)
            self_category = Category.find(categories_hash.self_category_id)
          when 112
            ResumeValues.new(self_category, adv, advert)
            self_category = Category.find(categories_hash.self_category_id)
          end

        end

        bar.increment!
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
          rest_app_category_id: 24,
          root_category_id: 338,
          self_category_id: 339,
          selling: {resale: 344, new_building: 345},
          for_rent: {daily: 347, for_a_long_time: 346},
          buy: {resale: 348, new_building: 349},
          take_off: {daily: 351, for_a_long_time: 350}
        },
        {
          rest_app_category_id: 27,
          root_category_id: 35,
          self_category_id: 35,
          accessories: {other: 534},
          woman: {shoes: 40, clothes: 38},
          man: {shoes: 41, clothes: 530}
        },
        {
          rest_app_category_id: 29,
          root_category_id: 5,
          self_category_id: 6,
          girls: {shoes: 19, clothes: 16},
          boys: {shoes: 18, clothes: 15},
          newborns: 17
        },
        {
          rest_app_category_id: 114,
          root_category_id: 175,
          self_category_id: 223
        },
        {
          rest_app_category_id: 115,
          root_category_id: 175,
          self_category_id: 199
        },
        {
          rest_app_category_id: 111,
          root_category_id: 459,
          self_category_id: 460
        },
        {
          rest_app_category_id: 112,
          root_category_id: 459,
          self_category_id: 461
        }

      ]
    end
  end
end
