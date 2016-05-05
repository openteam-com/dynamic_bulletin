module Avito
  class ChildValues
    def initialize(self_category, adv, advert, finded_age)
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

    def desc_or_title_inc?(d, t, arr)
      arr.each do |sub|
        if !d[sub].nil? || !t[sub].nil?
          return true
        end
      end
      false
    end
  end
end
