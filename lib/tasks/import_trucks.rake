namespace :import do
  desc 'safe import trucks from remote url'
  task trucks: :environment do
    AutoImporter.new('trucks')
  end
end
