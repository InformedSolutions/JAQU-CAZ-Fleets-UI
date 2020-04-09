# frozen_string_literal: true

class OrganisationsController < ApplicationController
  skip_before_action :authenticate_user!
  # checks if company name is present in session
  before_action :check_company_name, only: %i[new_credentials create email_sent]
  # checks if new account details is present in session
  before_action :check_account_details, only: %i[email_sent resend_email]
  # add data to session to render it in the text fields after using `Back` link
  before_action :add_credentials_to_session, only: %i[create]

  ##
  # Renders the create account name page.
  #
  # ==== Path
  #
  #    :GET /organisations
  #
  def new
    # Renders static page
  end

  ##
  # Validates submitted account name.
  # If successful, redirects to {:new_credentials}
  # [rdoc-ref:OrganisationsController.new_credentials]
  # If no, redirects to {:new}[rdoc-ref:OrganisationsController.new]
  #
  # ==== Path
  #
  #    POST /organisations
  #
  # ==== Params
  # * +company_name+ - string, account name e.g. 'Company name'
  #
  def set_name
    form = CompanyNameForm.new(company_name_params)
    session[:new_account] = { 'company_name' => form.company_name }
    if form.valid?
      redirect_to new_credentials_organisations_path
    else
      @error = form.errors.full_messages.join(',')
      render 'organisations/new'
    end
  end

  ##
  # Renders the new email and password page.
  #
  # ==== Path
  #
  #    GET /organisations/new_credentials
  #
  # ==== Params
  # * +company_name+ - string, account name stored in the session e.g. 'Company name'
  #
  def new_credentials
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
  #    POST /organisations/new_credentials
  #
  # ==== Params
  # * +company_name+ - string, account name stored in the session e.g. 'Company name'
  #
  def create
    user = CreateAccount.call(
      organisations_params: organisations_params,
      company_name: new_account[:company_name],
      host: root_url
    )
    session[:new_account].merge!(user.serializable_hash.stringify_keys)
    redirect_to email_sent_organisations_path
  rescue NewPasswordException => e
    @errors = e.errors_object
    render :new_credentials
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
    redirect_to email_sent_organisations_path
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
             email_verified_organisations_path
           else
             verification_failed_organisations_path
           end
    session[:new_account] = nil
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
    return if new_account[:company_name]

    Rails.logger.warn('Company name is missing in the session. Redirecting to :root_path')
    redirect_to root_path
  end

  # Checks if new account details is present in the session.
  # If not, redirects to root path.
  def check_account_details
    Rails.logger.warn('Checking credentials from the session')
    redirect_to root_path if (
      %i[company_name email admin user_id account_id account_name login_ip] - new_account.keys
    ).present?
  end

  # Add a new company credentials to the session
  def add_credentials_to_session
    Rails.logger.warn('Adding credentials to the session')
    new_account.merge!(
      'email' => organisations_params['email'],
      'email_confirmation' => organisations_params['email_confirmation']
    )
  end

  def new_account
    (session[:new_account] || {}).symbolize_keys
  end
end
