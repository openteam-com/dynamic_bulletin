require 'open-uri'
require 'nokogiri'
require 'json'

class TrucksParser < AutoParser
  private
  def parse_marks
    doc = nokogiri_object
    @start_time = Time.now

    @marks_data = doc.css('.auto').css('.cell-1').css('a').inject({}) do |hash, marka|
      hash[marka.children.first.text] = marka['href']; hash
    end

    puts "Количество моделей: #{marks_data.count}"
  end

  def parse_models
    marks_data.to_enum.with_index(1).each do |mark, index|
      key, value = mark
      doc = nokogiri_object("http://trucks.auto.ru" + value)
      puts "Парсинг модели №#{index} - #{key.capitalize}, осталось #{marks_data.count - index}"
      cc = 0
      models = doc.css('.auto').css('.group').css('a').inject([]) do |array, model|
        if cc > 1
          array << model.children.first.text
        end
        cc+=1; array
      end
      @results[key] = models
    end

    puts "Время работы: #{(Time.now - start_time).round}"
  end
end
