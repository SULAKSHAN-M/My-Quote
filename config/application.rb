require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Myquote
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = "UTC"
    config.i18n.default_locale = :en
    # Needed for URI::MailTo::EMAIL_REGEXP in User model
    require "uri"
  end
end
