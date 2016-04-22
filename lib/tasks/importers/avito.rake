require 'progress_bar'

namespace :avito do
  desc 'store data from rest_app for avito'
  task adverts_parse: :environment do
    categories = [9, 10, 11, 14, 19, 20, 21, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 38, 39, 40, 42, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 96, 97, 98, 99, 101, 102, 105, 106, 111, 112, 114, 115, 116]
    bar = ProgressBar.new categories.size
    categories = [9, 29]

    categories.each do |category_id|
      date_from = DateTime.new 2016, 03, 01

      3.times do
        RestAppParser.new(date_from: date_from.strftime('%Y-%m-%d'), category_id: category_id).parse!

        date_from += 1.day
      end

      bar.increment!
    end
  end

  desc 'apply avito data for our project'
  task adverts_import: :environment do
    Avito::RestAppImporter.new.parse
  end
end
