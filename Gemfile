source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.0"

gem "active_storage_validations", "~> 0.8.9"
gem "apexcharts"
gem "bcrypt", "~> 3.1", ">= 3.1.13"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap", "~> 4.5"
gem "cancancan", "~> 3.1"
gem "ckeditor", github: "galetahub/ckeditor"
gem "config", "~> 2.2", ">= 2.2.1"
gem "devise"
gem "faker", "~> 2.12"
gem "fast_jsonapi"
gem "figaro", "~> 1.2"
gem "font_awesome5_rails"
gem "friendly_id", "~> 5.4.0"
gem "grape"
gem "grape-jwt-authentication"
gem "grape-swagger"
gem "grape-swagger-entity"
gem "grape-swagger-rails"
gem "grape-swagger-representable"
gem "groupdate"
gem "i18n-js", "~> 3.7"
gem "image_processing", "~> 1.11"
gem "jbuilder", "~> 2.7"
gem "jquery-rails", "~> 4.4"
gem "jwt"
gem "kaminari", "~> 1.2", ">= 1.2.1"
gem "mini_magick", "~> 4.10", ">= 4.10.1"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-github"
gem "omniauth-google-oauth2"
gem "paranoia", "~> 2.4", ">= 2.4.2"
gem "puma", "~> 4.1"
gem "rack-cors"
gem "rails", "~> 6.0.3", ">= 6.0.3.2"
gem "rails-i18n"
gem "ransack", github: "activerecord-hackery/ransack"
gem "rolify", "~> 5.3"
gem "sass-rails", ">= 6"
gem "sidekiq", "~> 6.1", ">= 6.1.1"
gem "social-share-button"
gem "sprockets-rails", "~> 3.2", ">= 3.2.1"
gem "toastr-rails", "~> 1.0", ">= 1.0.3"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "mysql2"
  gem "pry-rails", "~> 0.3.9"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "bullet"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "database_cleaner-active_record"
  gem "rspec-sidekiq"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "webdrivers"
end

group :production do
  gem "pg"
  gem "unicorn"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
