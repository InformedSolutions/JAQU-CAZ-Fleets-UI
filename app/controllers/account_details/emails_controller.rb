# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update name for primary users
  #
  class EmailsController < ApplicationController
    include CheckPermissions
<<<<<<< HEAD
    include Devise::Models::RemoteAuthenticatable

    skip_before_action :authenticate_user!, only: %i[confirm_email validate_confirm_email]
    before_action -> { check_permissions(current_user.owner == true) }, except:
      %i[confirm_email validate_confirm_email]
    before_action :set_user_details, only: :edit_email

    ##
    # Renders the change email email address page for primary users
=======

    before_action -> { check_permissions(current_user.owner == true) }
    before_action :set_user_details, only: :edit

    ##
    # Renders the change email email address page for primary users.
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_email
    #
<<<<<<< HEAD
    def edit_email
=======
    def edit
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
      @errors = {}
    end

    ##
    # Performs update of the users email address
    #
    # ==== Path
    #
    #    :GET /non_primary_users/update_email
    #
<<<<<<< HEAD
    def update_email
=======
    def update
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
      form = AccountDetails::EditUserEmailForm.new(account_id: current_user.account_id, email: params[:email])
      if form.valid?
        update_owner_email(form.email)
        # TODO: CAZB-2640 - redirect to email sent page
        redirect_to primary_users_account_details_path
      else
        @errors = form.errors.messages
<<<<<<< HEAD
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
      @token = params[:token]
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
        sign_in_and_redirect(service)
      else
        render_confirm_email(service.errors)
=======
        render :edit
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
      end
    end

    private

    # Fetches user details from the API
    def set_user_details
<<<<<<< HEAD
      api_response = AccountsApi::Users.user(
=======
      api_response = AccountsApi.user(
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
        account_id: current_user.account_id,
        account_user_id: current_user.user_id
      )
      @user = AccountDetails::User.new(api_response)
    end

    # Sends request to API with change email request
    def update_owner_email(email)
<<<<<<< HEAD
      AccountsApi::Auth.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email.downcase,
        confirm_url: confirm_email_primary_users_url
      )
    end

    # Renders :confirm_email with assigned errors and token
    def render_confirm_email(errors)
      @token = params[:token]
      @errors = errors
      render :confirm_email
    end

    # Redirects to the dashboard page if user already logged in
    # If not, calling api and sign in via devise helper method before redirect
    def sign_in_and_redirect(service)
      return redirect_to dashboard_path if current_user

      user = authentication({
                              email: service.new_user_email,
                              password: service.password,
                              login_ip: request.remote_ip
                            })
      sign_in(user)
      redirect_to dashboard_path
    end
=======
      AccountDetails::Api.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email.downcase,
        # TODO: CAZB-2865 - confirm update email page
        confirm_url: primary_users_account_details_path
      )
    end
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
  end
end
