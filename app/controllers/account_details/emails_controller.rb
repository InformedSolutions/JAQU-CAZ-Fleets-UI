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
    before_action :set_user_details, only: :edit_email

    ##
    # Renders the change email email address page for primary users
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_email
    #
    def edit_email
      @errors = {}
    end

    ##
    # Performs update of the users email address
    #
    # ==== Path
    #
    #    :GET /non_primary_users/update_email
    #
    def update_email
      form = AccountDetails::EditUserEmailForm.new(account_id: current_user.account_id, email: params[:email])
      if form.valid?
        update_owner_email(form.email)
        session[:owners_new_email] = form.email
        redirect_to email_sent_primary_users_path
      else
        @errors = form.errors.messages
        render :edit_email
      end
    end

    ##
    # Renders the email sent page
    #
    # ==== Path
    #
    #    :GET /primary_users/email_sent
    #
    def email_sent
      @email = session[:owners_new_email]
    end

    ##
    # Call api which will resend a verification email after changing email process
    #
    # ==== Path
    #
    #    :GET /primary_users/resend_email
    #
    def resend_email
      update_owner_email(session[:owners_new_email])
      redirect_to email_sent_primary_users_path
    end

    ##
    # Renders the email address updated page
    #
    # ==== Path
    #
    #    :GET /primary_users/confirm_email
    #
    # ==== Params
    # * +token+ - uuid, required in the query
    #
    def confirm_email
      # renders static page
    end

    ##
    # Validates the token and password by calling AccountsApi::Users.confirm_email
    #
    # ==== Path
    #
    #    :GET /primary_users/validate_confirm_email
    #
    # ==== Params
    # * +token+ - token from the email, passes as a hidden param in the form
    # * +passwords+ - hash
    #   * +password+ - string, submitted password
    #   * +password_confirmation+ - string, submitted password confirmation
    #
    def validate_confirm_email
      service = AccountDetails::UpdateEmail.call(
        password: params.dig(:passwords, :password),
        password_confirmation: params.dig(:passwords, :password_confirmation),
        token: params[:token]
      )
      if service.valid?
        redirect_to dashboard_path
      else
        render_confirm_email(service.errors)
      end
    end

    private

    # Fetches user details from the API
    def set_user_details
      api_response = AccountsApi::Users.user(
        account_id: current_user.account_id,
        account_user_id: current_user.user_id
      )
      @user = AccountDetails::User.new(api_response)
    end

    # Sends request to API with change email request
    def update_owner_email(email)
      AccountsApi::Auth.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email.downcase,
        confirm_url: primary_users_account_details_url
      )
    end

    # Renders :confirm_email with assigned errors and token
    def render_confirm_email(errors)
      @token = params[:token]
      @errors = errors
      render :confirm_email
    end
  end
end
