require 'progress_bar'

class AutoImporter
  attr_reader :data, :type, :property

  def initialize(type = 'cars')
    @type = type
    select_type
    do_import
  end

  def select_type
    case type
    when 'cars'
      @data = JSON.load CarsParser.new(url: Settings['importers.cars_url']).do_parse
      @property = Property.find_or_create_by!(id: 88, title: 'Марка и модель')

    when 'trucks'
      @data = JSON.load TrucksParser.new(url: Settings['importers.trucks_url']).do_parse
      @property = Property.find_or_create_by!(id: 114, title: 'Марка и модель')
    end
  end

  def do_import
    pb = ProgressBar.new data.count
    data.each do |mark, models|
      parent = property.hierarch_list_items.find_or_create_by title: mark

      models.each do |model|
        parent.children.find_or_create_by title: model
      end

      pb.increment!
    end
  end
end

