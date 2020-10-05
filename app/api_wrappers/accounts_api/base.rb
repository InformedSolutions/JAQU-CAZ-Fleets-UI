# frozen_string_literal: true

##
# Module used for
module AccountsApi
  ##
  # API wrapper for connecting to Accounts API.
  # Wraps methods regarding user management.
  # See {FleetsApi}[rdoc-ref:FleetsApi] for fleet related actions.
  #
  class Base < BaseApi
    base_uri "#{ENV.fetch('ACCOUNTS_API_URL', 'localhost:3001')}/v1"
  end
end
