Dir[Rails.root + 'app/models/properties/*.rb'].each do |path|
    require path
end
