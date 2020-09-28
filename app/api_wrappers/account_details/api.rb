# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  # API wrapper for connecting to Accounts API
  class Api < AccountsApi
    class << self
      ##
      # Calls +/v1/users/:accountUserId+ endpoint with +GET+ method and returns account details
      #
      # ==== Attributes
      #
      # * +account_user_id+ - uuid, id of the user account
      #
      # ==== Result
      #
      # Returned account details will have the following fields:
      # * +accountUserId+ - uuid, ID of the user
      # * +accountId+ - uuid, ID of the account
      # * +accountName+ - string, name of the account
      # * +name+ - string, name of the user
      # * +email+ - email, email of the user
      # * +owner+ - boolean, determines if the user is owner
      # * +removed+ - boolean, determines if the user was removed
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - user not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def account_details(account_user_id:)
        log_action('Getting account details')
        request(:get, "/users/#{account_user_id}")
      end
    end
  end
end
