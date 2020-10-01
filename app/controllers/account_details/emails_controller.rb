# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update name for primary users
  #
  class EmailsController < ApplicationController
    include CheckPermissions

    before_action -> { check_permissions(current_user.owner == true) }
    before_action :set_user_details, only: :edit

    ##
    # Renders the change email email address page for primary users.
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_email
    #
    def edit
      @errors = {}
    end

    ##
    # Performs update of the users email address
    #
    # ==== Path
    #
    #    :GET /non_primary_users/update_email
    #
    def update
      form = AccountDetails::EditUserEmailForm.new(account_id: current_user.account_id, email: params[:email])
      if form.valid?
        update_owner_email(form.email)
        # TODO: CAZB-2640 - redirect to email sent page
        redirect_to primary_users_account_details_path
      else
        @errors = form.errors.messages
        render :edit
      end
    end

    private

    # Fetches user details from the API
    def set_user_details
      api_response = AccountsApi.user(
        account_id: current_user.account_id,
        account_user_id: current_user.user_id
      )
      @user = AccountDetails::User.new(api_response)
    end

    # Sends request to API with change email request
    def update_owner_email(email)
      AccountDetails::Api.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email.downcase,
        # TODO: CAZB-2865 - confirm update email page
        confirm_url: primary_users_account_details_path
      )
    end
  end
end
