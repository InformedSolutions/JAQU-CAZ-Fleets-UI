# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.1'

gem 'aws-sdk-s3'
gem 'bootsnap', require: false
gem 'devise'
gem 'haml'
gem 'httparty'
gem 'possessive'
gem 'puma'
gem 'redis'
gem 'sdoc', require: false
gem 'sqlite3'
gem 'turbolinks'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker'

group :development, :test do
  gem 'dotenv-rails'
  gem 'haml-rails'
  gem 'rspec-rails'
  gem 'ruby_jard'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'fakeredis'
  gem 'i18n-tasks'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rubocop-rails'
  gem 'scss_lint-govuk', require: false
  gem 'selenium-webdriver'
  gem 'show_me_the_cookies'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'webdrivers'
  gem 'webmock'
  gem 'yard'
end
