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
    #    :GET /primary_users/update_email
    #
    def update_email
    def update
      form = AccountDetails::EditUserEmailForm.new(account_id: current_user.account_id, email: params[:email])
      if form.valid?
        update_owner_email(form.email)
        # TODO: CAZB-2640 - redirect to email sent page
        redirect_to primary_users_account_details_path
      return redirect_to primary_users_account_details_path if current_user.email == email_params

      form = AccountDetails::EditUserEmailForm.new(account_id: current_user.account_id, email: email_params)
      if form.valid?
        update_email_and_redirect(form)
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
      AccountDetails::Api.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email.downcase,
        # TODO: CAZB-2865 - confirm update email page
        confirm_url: primary_users_account_details_path
      )
    end

    # Update user email and redirect to the email send page
    def update_email_and_redirect(form)
      update_owner_email(form.email)
      session[:owners_new_email] = form.email
      redirect_to email_sent_primary_users_path
    end

    # downcase email params
    def email_params
      params[:email].downcase
    end

    # Sends request to API with change email request
    def update_owner_email(email)
      AccountsApi::Auth.update_owner_email(
        account_user_id: current_user.user_id,
        new_email: email,
        confirm_url: confirm_email_primary_users_url
      )
    end
  end
end
