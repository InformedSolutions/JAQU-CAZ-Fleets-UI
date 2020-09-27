# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update password for primary and non-primary users
  #
  class PasswordsController < ApplicationController
    include CheckPermissions

    ##
    # Renders the update password page
    #
    # ==== Path
    #
    #    :GET /edit_password
    #
    def edit
      # renders the update password page
    end

    ##
    # Updates user password by calling AccountsApi.update_password
    #
    # ==== Path
    #
    #    :PATCH /edit_password
    #
    def update
      form = UpdatePasswordForm.new(
        user_id: current_user.user_id,
        old_password: params.dig(:passwords, :old_password),
        password: params.dig(:passwords, :password),
        password_confirmation: params.dig(:passwords, :password_confirmation)
      )

      return rerender_edit(form.errors.messages) unless form.valid? && form.submit

      redirect_to_account_management
    end

    private

    # Renders :edit with assigned errors
    def rerender_edit(errors)
      @errors = errors
      render :edit
    end

    # Redirects to a proper account management page
    def redirect_to_account_management
      url = current_user.owner ? primary_users_account_details_path : non_primary_users_account_details_path
      redirect_to url
    end
  end
end
