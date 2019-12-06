# frozen_string_literal: true

class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!

  ##
  # Renders the reset password page.
  #
  # ==== Path
  #
  #    :GET /passwords/reset
  #
  def reset
    # renders static page
  end

  ##
  # Validates submitted email_address.
  # If successful, redirects to {new_user_session}[rdoc-ref:Devise::SessionController.new]
  # If no, renders {reset} [rdoc-ref:PasswordsController.new]
  #
  # ==== Path
  #
  #    :POST /passwords/reset
  #
  def validate
    form = ResetPasswordForm.new(email_address_params)
    if form.valid?
      # TO DO: Send reset link to email address
      redirect_to new_user_session_path
    else
      @errors = form.errors.messages
      render :reset
    end
  end

  private

  # Returns the list of permitted params
  def email_address_params
    params.require(:passwords).permit(:email_address)
  end
end
