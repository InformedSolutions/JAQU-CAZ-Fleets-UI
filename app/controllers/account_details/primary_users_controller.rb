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
    before_action :set_account_details, only: %i[primary_account_details edit_name]

    ##
    # Renders the management page for primary users.
    #
    # ==== Path
    #
    #    :GET /primary_account_details
    #
    def primary_account_details
      # Renders the management page for primary users.
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
    def update_name
      form = AccountDetails::EditCompanyNameForm.new(account_id: current_user.account_id,
                                                     company_name: params[:company_name])

      if form.valid? && form.submit
        redirect_to primary_users_account_details_path
      else
        @errors = form.errors.messages
        render :edit_name
      end
    end

    private

    # Fetches account details from the API
    def set_account_details
      api_response = AccountDetails::Api.account_details(account_user_id: current_user.user_id)
      @user = AccountDetails::User.new(api_response)
    end
  end
end
