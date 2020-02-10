# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2'

gem 'aws-sdk-s3'
gem 'aws-sdk-sqs'
gem 'bootsnap', require: false
gem 'brakeman'
gem 'bundler-audit'
gem 'devise'
gem 'haml'
gem 'httparty'
gem 'logstash-logger'
gem 'puma'
gem 'redis'
gem 'rubocop-rails'
gem 'sdoc', require: false
gem 'sqlite3'
gem 'turbolinks'
gem 'webpacker'
gem 'will_paginate', require: 'will_paginate/array'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'haml-rails'
  gem 'rspec-rails'
  gem 'scss_lint-govuk', require: false
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'show_me_the_cookies'
  gem 'simplecov', require: false
  gem 'webdrivers'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
