require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DynamicBulletin
  class Application < Rails::Application
    config.time_zone = 'Novosibirsk'

    config.i18n.default_locale = :ru
    config.assets.initialize_on_precompile = false
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += %W[
                              #{config.root}/lib
                              #{config.root}/lib/searchers
                              #{config.root}/lib/importers
                              #{config.root}/lib/importers/avito
                              #{config.root}/lib/parsers
                              #{config.root}/lib/parsers/auto
                              #{config.root}/lib/parsers/avito
                              #{config.root}/lib/tasks/*
                              ]
  end
end
