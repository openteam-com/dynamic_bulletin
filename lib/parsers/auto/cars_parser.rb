require 'open-uri'
require 'nokogiri'
require 'json'

class CarsParser < AutoParser
  private
  def parse_marks
    doc = nokogiri_object
    @start_time = Time.now

    @marks_data = doc.css('.mmm__item').inject({}) do |hash, marka|
      hash[marka.children.first.children.first.text] = marka.children.first['href']; hash
    end

    puts "Количество моделей: #{marks_data.count}"
  end

  def parse_models
    marks_data.to_enum.with_index(1).each do |mark, index|
      key, value = mark
      doc = nokogiri_object("https:#{value}")
      puts "Парсинг модели №#{index} - #{key.capitalize}, осталось #{marks_data.count - index}"

      models = doc.css('.mmm__item').inject([]) do |array, model|
        array << model.children.first.text; array
      end

      @results[key] = models
    end

    puts "Время работы: #{(Time.now - start_time).round}"
  end
end
