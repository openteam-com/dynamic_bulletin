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
          advert = case info.rest_app_category_id
                   when 9
                     CarValues.new(self_category, adv).return_advert
                   when 24
                     ApartmentValues.new(self_category, adv).return_advert
                   when 27
                     ClothesValues.new(self_category, adv).return_advert
                   when 29
                     ChildValues.new(self_category, adv).return_advert
                   when 114, 115
                     ServiceValues.new(self_category, adv).return_advert
                   when 111
                     JobValues.new(self_category, adv).return_advert
                   when 112
                     ResumeValues.new(self_category, adv).return_advert
                   end

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
              #puts ex.inspect
            end

            image = advert.images.new
            image.image = file
            image.save
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
