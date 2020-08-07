# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FleetsUI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Load custom Devise strategies
    config.autoload_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    # feedback url
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', 'https://defragroup.eu.qualtrics.com/jfe/form/SV_7U7lt37vNismJI9')
    # payments ui url
    config.x.payments_ui_url = ENV.fetch('PAYMENTS_UI_URL', 'dev.paycleanairzonecharge.co.uk')
    # service name for whole app
    config.x.service_name = 'Drive in a Clean Air Zone'

    # timeout the user session without activity.
    config.x.session_timeout_in_min = ENV.fetch('SESSION_TIMEOUT', 15).to_i

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'
    config.x.time_format = '%d %B %Y %H:%M:%S %Z'
    config.x.feature_direct_debits = ENV.fetch('FEATURE_DIRECT_DEBITS', 'false')
  end
end
