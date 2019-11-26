# frozen_string_literal: true

class OrganisationsController < ApplicationController
  def new_name
    # Renders static page
  end

  def create_name
    redirect_to email_address_and_password_path
  end

  def new_password
    # Renders static page
  end

  def create_account
    CreateAccountService.call(user_params: user_params)
    redirect_to email_sent_path
  rescue NewPasswordException => e
    @errors = e.errors_object
    render :new_password
  end

  def email_sent
    # Renders static page
  end

  private

  # Returns the list of permitted params
  def user_params
    params.require(:email_and_password_form).permit(:email, :password, :password_confirmation)
  end
end
