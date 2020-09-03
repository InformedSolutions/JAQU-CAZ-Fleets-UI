# frozen_string_literal: true

# Checks if no external calls are being performed during tests
require 'webmock/rspec'
# Checks code coverage
require 'simplecov'

SimpleCov.start 'rails' do
  # minimum coverage percentage expected
  minimum_coverage 90
  # ignore next folders and files
  add_filter %w[
    app/channels/application_cable/channel.rb
    app/channels/application_cable/connection.rb
    app/jobs/application_job.rb
    app/mailers/application_mailer.rb
    lib/
    config/
  ]
end
