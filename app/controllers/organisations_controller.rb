# frozen_string_literal: true

class OrganisationsController < ApplicationController
  skip_before_action :authenticate_user!
  # checks if company name is present in session
  before_action :check_company_name, only: %i[new_email_and_password create_account]
  # checks if new account details is present in session
  before_action :check_account_details, only: %i[email_sent resend_email]
  ##
  # Renders the create account name page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/create-account-name
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
  # * +company_name+ - string, account name e.g. 'Company name'
  #
  def create_name
    form = CompanyNameForm.new(company_name_params)
    if form.valid?
      session[:company_name] = form.company_name
      redirect_to email_address_and_password_path
    else
      @error = form.errors.full_messages.join(',')
      render 'organisations/new_name'
    end
  end

  ##
  # Renders the new email and password page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/email-address-and-password
  #
  def new_email_and_password
    # Renders static page
  end

  ##
  # Validates submitted email and password.
  # If successful, redirects to {email-sent}[rdoc-ref:OrganisationsController.email_sent]
  # If no, redirects to {new_email_and_password}
  # [rdoc-ref:OrganisationsController.new_email_and_password]
  #
  # ==== Path
  #
  #    POST /fleets/organisation-account/create-account-name
  #
  # ==== Params
  # * +company_name+ - string, account name e.g. 'Company name'
  #
  def create_account
    user = CreateAccount.call(
      organisations_params: organisations_params,
      company_name: session[:company_name],
      host: root_url
    )
    session[:new_account] = user.serializable_hash
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
  #    :GET /fleets/organisation-account/email-sent
  #
  def email_sent
    @email = User.new(session[:new_account]).email
  end

  def resend_email
    user = User.new(session[:new_account])
    Sqs::VerificationEmail.call(user: user, host: root_url)
    redirect_to email_sent_path
  end

  ##
  # Checks the verification token.
  # If the token is valid it calls backend to mark the email address as verified
  # and redirects to :email_verified
  # If verification fails it redirects to :verification_failed
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/email-verification
  #
  # ==== Params
  # * +token+ - string, encrypted token with verification data
  #
  def email_verification
    path = if VerifyAccount.call(token: params[:token])
             email_verified_path
           else
             verification_failed_path
           end
    redirect_to path
  end

  ##
  # Renders the email verified page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/email-verified
  #
  def email_verified
    @user = User.new
  end

  ##
  # Renders the error page if verification fails.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/verification-failed
  #
  def verification_failed
    # Renders static page
  end

  private

  # Returns the list of permitted params
  def organisations_params
    params.require(:organisations).permit(
      :email,
      :email_confirmation,
      :password,
      :password_confirmation
    )
  end

  # Returns the list of permitted params
  def company_name_params
    params.require(:organisations).permit(:company_name)
  end

  # Checks if company name is present in the session.
  # If not, redirects to root path.
  def check_company_name
    return if session[:company_name]

    Rails.logger.warn('Company name is missing in the session. Redirecting to :root_path')
    redirect_to root_path
  end

  # Checks if new account details is present in the session.
  # If not, redirects to root path.
  def check_account_details
    redirect_to root_path unless session[:new_account]
  end
end
