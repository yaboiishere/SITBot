require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups(
#   assets: %i[development test],
#   pry:    %i[development test],
# ))
# load pry for production console
# Bundler.require(:pry) if defined?(Rails::Console)

Bundler.require(*Rails.groups)

module TelegramBotApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
  	config.time_zone = "Sofia"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end