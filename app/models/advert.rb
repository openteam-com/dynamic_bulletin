class Advert < ActiveRecord::Base
  after_save :set_title
  belongs_to :category
  belongs_to :user

  has_many :values, dependent: :delete_all
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :values
  accepts_nested_attributes_for :images, allow_destroy: true

  after_initialize :build_empty_values, if: :new_record?

  alias_attribute :to_s, :title

  def title
    $redis.get(id)
  end

  def set_title
    string_title = ''
    if category.title ==  "Легковые автомобили"
      string_title = get_value_hierarch('марка и модель', false) +
        get_value('год', false) +
        get_value('пробег', true) +
        get_value('мощность', true) +
        get_value('кузов', true) +
        get_value('привод', true)
    elsif category.root.id == 338 #вся недвижимость
      string_title = get_value('комнат', true) +
        get_value('площадь', false) +
        get_value('этажей', true) +
        get_value('страна', false)
    end
    if string_title == ''
      values.each do |value|
        string_title += get_value(value.property, true)
      end
    end
    string_title = read_attribute(:description) if string_title == ''
    $redis.set(id, string_title.strip.chomp(','))
  end

  def get_value(property_title, need_prefix)
    property_finded = category.properties.where('title ilike ?', "%#{property_title}%").first
    return '' if property_finded.nil? || property_finded.kind == 'unlimited_list'
    string_value = property_finded.values.where(:advert_id => id).find { |v| v if v.value != nil }.try(:value).try(:to_s)
    if !string_value.nil?
      string_value += ', '
      string_value = property_finded.title + ': ' + string_value if need_prefix
    else
      string_value = ''
    end
    string_value
  end

  def get_value_hierarch(property_title, need_prefix)
    property_finded = category.properties.where('title ilike ?', "%#{property_title}%").first
    return '' if property_finded.nil?
    lists = property_finded.values.where(:advert_id => id).find {|v| v if v.hierarch_list_item != nil}.try(:hierarch_list_item).try(:path).try(:to_a)
    if lists.try(:size) == 2
      string_value = lists[0].title + ' ' + lists[1].title + ', '
      string_value = property_finded.title + ': ' + string_value if need_prefix
    else
      string_value = ''
    end
    string_value
  end

  private
  def build_empty_values
    return unless category

    category.properties.each do |property|
      values << property.values.new unless values.select {|v| v.property == property}.any?
    end
  end

  searchable include: [:values] do
    integer :list_item_ids, multiple: true do
      values.map { |v| v.list_items.map(&:id) + values.map(&:list_item).compact.map(&:id) }.flatten.compact.uniq
    end

    integer :hierarch_list_item_ids, multiple: true do
      values.map(&:hierarch_list_item).compact.map(&:id)
    end

    integer(:category_id) { category.id }
  end
end

# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  description :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
