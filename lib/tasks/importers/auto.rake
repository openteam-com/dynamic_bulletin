namespace :import do
  desc 'safe import cars from remote url'
  task cars: :environment do
    AutoImporter.new('cars')
  end

  desc 'safe import trucks from remote url'
  task trucks: :environment do
    AutoImporter.new('trucks')
  end
end
