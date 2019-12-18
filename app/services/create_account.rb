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
    user = User.serialize_from_api(perform_api_call)
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
    AccountsApi.create_account(
      email: organisations_params[:email],
      password: organisations_params[:password],
      company_name: company_name
    )
  rescue BaseApi::Error422Exception => e
    parse_422_error(e.body['details'])
  end

  # Check if api returns 422 errors. If yes assign error messages to error object and
  # raise `NewPasswordException` exception
  def parse_422_error(enums)
    errors = {}

    check_email_uniq(enums, errors)
    check_email_format(enums, errors)
    check_password_complexity(enums, errors)

    raise(NewPasswordException, errors)
  end

  # add error to +errors+ object if `emailNotUnique` enum is present
  def check_email_uniq(enums, errors)
    (errors[:email] ||= []) << I18n.t('email.errors.exists') if enums.include?('emailNotUnique')
  end

  # add error to +errors+ object if `emailNotValid` enum is present
  def check_email_format(enums, errors)
    return unless enums.include?('emailNotValid')

    (errors[:email] ||= []) << I18n.t('input_form.errors.invalid_format', attribute: 'Email')
  end

  # add error to +errors+ object if `passwordNotValid` enum is present
  def check_password_complexity(enums, errors)
    return unless enums.include?('passwordNotValid')

    (errors[:password] ||= []) << I18n.t(
      'input_form.errors.password_complexity',
      attribute: 'Password'
    )
  end

  # It sends the verification email to the user via SQS.
  #
  # It raises BaseApi::Error500Exception if it fails.
  def send_verification_email(user)
    Sqs::VerificationEmail.call(user: user, host: host)
  end
end
