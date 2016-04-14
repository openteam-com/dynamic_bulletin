namespace :auto do
  desc 'safe import cars from remote url'
  task cars_import: :environment do
    AutoImporter.new('cars')
  end

  desc 'safe import trucks from remote url'
  task trucks_import: :environment do
    AutoImporter.new('trucks')
  end
end
