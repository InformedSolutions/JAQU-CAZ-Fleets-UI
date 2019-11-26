# frozen_string_literal: true

class OrganisationsController < ApplicationController
  ##
  # Renders the create account name page.
  #
  # ==== Path
  #
  #    GET /fleets/organisation-account/create-account-name
  #
  def new_name
    # Renders static page
  end

  ##
  # Validates submitted account name.
  # If successful, redirects to {new_email_and_password}
  # [rdoc-ref:OrganisationsController.new_email_and_password]
  # If no, redirects to {new_name}[rdoc-ref:OrganisationsController.new_name]
  #
  # ==== Path
  #
  #    POST /fleets/organisation-account/create-account-name
  #
  # ==== Params
  # * +name+ - account name
  #
  def create_name
    if company_params['name'].present?
      redirect_to email_address_and_password_path
    else
      redirect_to create_account_name_path, alert: 'Enter the company name'
    end
  end

  ##
  # Renders the new email and password page.
  #
  # ==== Path
  #
  #    GET /fleets/organisation-account/email-address-and-password
  #
  def new_email_and_password
    # Renders static page
  end

  ##
  # Validates submitted email and password.
  # If successful, redirects to {email_sent}[rdoc-ref:OrganisationsController.email_sent]
  # If no, redirects to {new_email_and_password}
  # [rdoc-ref:OrganisationsController.new_email_and_password]
  #
  # ==== Path
  #
  #    POST /fleets/organisation-account/create-account-name
  #
  # ==== Params
  # * +name+ - account name
  #
  def create_account
    CreateAccountService.call(user_params: user_params)
    redirect_to email_sent_path
  rescue NewPasswordException => e
    @errors = e.errors_object
    render :new_email_and_password
  end

  ##
  # Renders the email sent page.
  #
  # ==== Path
  #
  #    GET /fleets/organisation-account/email_sent
  #
  def email_sent
    # Renders static page
  end

  private

  # Returns the list of permitted params
  def user_params
    params.require(:email_and_password_form).permit(
      :email,
      :email_confirmation,
      :password,
      :password_confirmation
    )
  end

  # Returns the list of permitted params
  def company_params
    params.require(:company).permit(:name)
  end
end
