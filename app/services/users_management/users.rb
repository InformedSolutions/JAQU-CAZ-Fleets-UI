# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Service used to fetch the list of users and display only not owner and not removed users
  #
  class Users < BaseService
    ##
    # Initializer method
    #
    # ==== Params
    #
    # * +account_id+ - uuid, id of the account
    #
    def initialize(account_id:)
      @account_id = account_id
    end

    # It calls api and filter out removed users and owner users from the users list and then sorts by name in alphabetical order
    # Then converting response data to User objects
    #
    def call
      filtered_and_sorted.map { |user_data| UsersManagement::User.new(user_data) }
    end

    # Filtering out removed users and owner from the api response
    def filtered
      api_call.reject { |user| user['owner'] == true || user['removed'] == true }
    end

    private

    # Filtering out removed users and owner from the api response and then sorts by name in alphabetical order
    def filtered_and_sorted
      api_call.reject { |user| user['owner'] == true || user['removed'] == true }
              .sort_by { |user| user['name'] }
    end

    # Call the api go get all users
    def api_call
      AccountsApi.users(account_id: account_id)
    end

    # Attributes used internally
    attr_reader :account_id
  end
end
