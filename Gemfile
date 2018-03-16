# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "pg"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.3"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"

gem "bootstrap", "~> 4.0.0.beta3"
gem "jquery-rails"

# Use Uglifier as compressor for JavaScript assets
gem "rest-client"
gem "uglifier", ">= 1.3.0"

gem "dropzonejs-rails"
gem "mailgun-ruby", "~>1.1.6"
gem "rubyzip"

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "foreman"
gem "jbuilder", "~> 2.5"
gem "sidekiq"

gem "devise"
gem "google-cloud-storage"
gem "paperclip", "~> 5.0.0"
gem "paperclip-gcs"
gem "rqrcode"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 2.13"
  gem "mailcatcher", require: false
  gem "mina", require: false
  gem "rubocop", require: false
  gem "selenium-webdriver"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
