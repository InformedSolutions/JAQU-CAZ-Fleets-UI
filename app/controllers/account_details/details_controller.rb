# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to manage user settings
  #
  class DetailsController < ApplicationController
    ##
    # Renders the update password page
    #
    # ==== Path
    #
    #    :GET /edit_password
    #
    def edit_password
      # renders a static page
    end

    ##
    # Updates user password by calling AccountsApi.update_password
    #
    # ==== Path
    #
    #    :PATCH /update_password
    #
    def update_password
      form = UpdatePasswordForm.new(
        user_id: current_user.user_id,
        old_password: params.dig(:passwords, :old_password),
        password: params.dig(:passwords, :password),
        password_confirmation: params.dig(:passwords, :password_confirmation)
      )

      return rerender_edit_password(form.errors.messages) unless form.valid? && form.submit

      redirect_to_account_management
    end

    private

    # Renders :edit_password with assigned errors
    def rerender_edit_password(errors)
      @errors = errors
      render :edit_password
    end

    # Redirects to correct account management page
    def redirect_to_account_management
      redirect_to current_user.owner ? primary_users_path : non_primary_users_path
    end
  end
end
