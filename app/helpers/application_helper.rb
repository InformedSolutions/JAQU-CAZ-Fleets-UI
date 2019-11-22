# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation
#
module ApplicationHelper
  # Returns name of service, eg. 'FleetsUI'.
  def service_name
    Rails.configuration.x.service_name
  end
end
