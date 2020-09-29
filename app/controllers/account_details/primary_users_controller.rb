# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to manage the primary user settings
  #
  class PrimaryUsersController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner) }

    ##
    # Renders the management page for primary users.
    #
    # ==== Path
    #
    #    :GET /primary_account_details
    #
    def primary_account_details
      api_response = AccountDetails::Api.account_details(account_user_id: current_user.user_id)
      @user = AccountDetails::User.new(api_response)
    end

    ##
    # Renders update company name page.
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_name
    #
    def edit_name
      @errors = {}
    end

    ##
    # Performs update of the users company name.
    #
    # ==== Path
    #
    #    :PATCH /primary_users/update_name
    #
    def update_name; end
  end
end
