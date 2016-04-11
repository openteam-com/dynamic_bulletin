require 'progress_bar'
require_relative '../parsers/trucks.rb'
class AutoImporter
  attr_reader :data, :type

  def initialize(type = 'cars')
    @type = type
    select_type
    do_import
  end

  def select_type
    case type
    when 'cars'
      RestClient::Request.execute(method: :get, url: Settings['importers.auto_importer_json_link']) do |response, request, result, &block|
        @data = JSON.load response
      end
    when 'trucks'
      @data = JSON.load TruckParser.new(url: "http://trucks.auto.ru/trucks/").do_parse
    end
  end

  def do_import
    case type
    when 'cars', 'trucks'
      pb = ProgressBar.new data.count
      if type == 'cars'
        property_id = 88
      else
        property_id = 114
      end

      data.each do |mark, models|
        parent = HierarchListItem.find_or_create_by title: mark, property_id: property_id

        models.each do |model|
          parent.children.find_or_create_by title: model
        end

        pb.increment!
      end
    end
  end
end

