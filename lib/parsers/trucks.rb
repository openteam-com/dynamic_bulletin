require 'open-uri'
require 'nokogiri'
require 'json'

class TruckParser
  attr_reader :url, :results, :start_time,
    :marks_data, :models

  def initialize(args = {})
    @url = args[:url]
    @results = {}
  end

  def do_parse
    parse_marks
    parse_models
    results.to_json
  end

  private
  def parse_marks
    doc = nokogiri_object
    @start_time = Time.now

    @marks_data = doc.css('.auto').css('.cell-1').css('a').inject({}) do |hash, marka|
      hash[marka.children.first.text] = marka['href']; hash
    end
    puts "Count of model = #{marks_data.count}"
  end

  def parse_models
    marks_data.to_enum.with_index(1).each do |mark, index|
      key, value = mark
      doc = nokogiri_object("http://trucks.auto.ru" + value)
      puts "Parsed #{index} model, called #{key.capitalize}, remaining #{marks_data.count - index} models"
      cc = 0
      models = doc.css('.auto').css('.group').css('a').inject([]) do |array, model|
        if cc > 1
          array << model.children.first.text
        end
        cc+=1; array
      end
      @results[key] = models
    end

    puts "Parsed for #{(Time.now - start_time).round} seconds"
  end

  def nokogiri_object(url = @url)
    Nokogiri::HTML(open(url))
  end
end

#TruckParser.new(filename: "output.txt", url: "http://trucks.auto.ru/trucks/").do_parse
