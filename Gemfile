source "https://rubygems.org"

gem "bootsnap", require: false
gem "dartsass-rails", "~> 0.5.1"
gem "govuk_publishing_components"
gem "importmap-rails"
gem "jbuilder"
gem "puma"
gem "rails", "8.0.2"
gem "sprockets-rails"
gem "sqlite3"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  # Debugging and testing tools
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails"
  gem "rubocop-govuk", require: false
end

group :development do
  # Console on exceptions pages
  gem "foreman"
  gem "web-console"
end

group :test do
  # System testing
  gem "capybara"
  gem "selenium-webdriver"
end
