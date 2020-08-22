require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module InternRubyKindmateClone
  class Application < Rails::Application
    config.load_defaults 6.0

    # i18n configurations
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.middleware.use I18n::JS::Middleware

    # Remote auth js
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.exceptions_app = self.routes

    # Setup CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV["default_url"]
        resource "*", headers: :any, methods: %i(get post put patch delete options)
      end
    end
  end
end
