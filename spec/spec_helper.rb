# frozen_string_literal: true

# Checks if no external calls are being performed during tests
require 'webmock/rspec'
# Checks code coverage
require 'simplecov'
# Checks coverage of I18n keys
require 'i18n/coverage'

# Run check only on CI
I18n::Coverage.start if ENV['I18N_COVERAGE']

SimpleCov.start 'rails' do
  # minimum coverage percentage expected
  minimum_coverage 90
  # ignore next folders and files
  add_filter %w[
    app/models/application_record.rb
    lib/
    config/
  ]
end
