# frozen_string_literal: true

##
# Service used to validates user params and performs call to API
#
class CreateAccount < BaseService
  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +organisations_params+ - hash, email and password submitted by the user
  # * +company_name+ - string, the company name submitted by the user
  # * +host+ - URL, the current host of an app
  #
  def initialize(organisations_params:, company_name:, host:)
    @organisations_params = organisations_params
    @company_name = company_name
    @host = host
  end

  # The caller method for the service.
  # It invokes validating,
  # performs call to API if validation not raises exception and
  # sends verification email.
  def call
    validate_user_params
    user = perform_api_call
    send_verification_email(user)
    user
  end

  private

  # Attribute used internally
  attr_reader :organisations_params, :company_name, :user, :host

  # Validate user params.
  # Raises `NewPasswordException` exception if validation failed.
  def validate_user_params
    form = EmailAndPasswordForm.new(organisations_params)
    return if form.valid?

    log_invalid_params(form.errors.full_messages)
    raise NewPasswordException, form.errors.messages
  end

  # Performs the API call to create a new account.
  #
  # It returns a new User class instance.
  def perform_api_call
    AccountsApi.create_organization(
      email: organisations_params[:email],
      _password: organisations_params[:password],
      _company_name: company_name
    )
  end

  # It sends the verification email to the user via SQS.
  #
  # It raises BaseApi::Error500Exception if it fails.
  def send_verification_email(user)
    message_id = Sqs::VerificationEmail.call(user: user, host: host)
    return if message_id

    raise BaseApi::Error500Exception.new(
      500,
      'SQS unavailable',
      message: I18n.t('verification_email.error')
    )
  end
end
