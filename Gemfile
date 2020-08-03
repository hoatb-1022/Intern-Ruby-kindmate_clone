source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.0"

gem "active_storage_validations", "~> 0.8.9"
gem "bcrypt", "~> 3.1", ">= 3.1.13"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap", "~> 4.5"
gem "ckeditor", github: "galetahub/ckeditor"
gem "config", "~> 2.2", ">= 2.2.1"
gem "faker", "~> 2.12"
gem "figaro", "~> 1.2"
gem "font_awesome5_rails"
gem "i18n-js", "~> 3.7"
gem "image_processing", "~> 1.11"
gem "jbuilder", "~> 2.7"
gem "jquery-rails", "~> 4.4"
gem "kaminari", "~> 1.2", ">= 1.2.1"
gem "mini_magick", "~> 4.10", ">= 4.10.1"
gem "mysql2"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.3", ">= 6.0.3.2"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "sprockets-rails", "~> 3.2", ">= 3.2.1"
gem "toastr-rails", "~> 1.0", ">= 1.0.3"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "pry-rails", "~> 0.3.9"
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
