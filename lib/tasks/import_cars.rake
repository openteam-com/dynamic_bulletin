namespace :import do
  desc 'safe import cars from remote url'
  task cars: :environment do
    AutoImporter.new
  end
end
