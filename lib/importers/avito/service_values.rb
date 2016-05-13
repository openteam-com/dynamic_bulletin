module Avito
  class ServiceValues
    attr_reader :advert

    def initialize(self_category, adv)
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

      @advert = self_category.adverts.new(description: adv['description'])
      advert.save
    end

    def return_advert
      advert
    end
  end
end
