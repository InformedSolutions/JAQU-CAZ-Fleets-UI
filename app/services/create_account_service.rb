# frozen_string_literal: true

##
# Service used to validates user params and performs call to API
#
class CreateAccountService < BaseService
  # Attribute used internally
  attr_reader :organisations_params, :email, :password, :company_name
  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +organisations_params+ - hash, email and password submitted by the user
  # * +company_name+ - string, the company name submitted by the user
  def initialize(organisations_params:, company_name:)
    @organisations_params = organisations_params
    @email = organisations_params['email']
    @password = organisations_params['password']
    @company_name = company_name
  end

  # The caller method for the service. It invokes validating.
  # And perform call to API if validation not raises exception.
  def call
    validate_user_params
    perform_api_call
  end

  private

  # Validate user params.
  # Raises `NewPasswordException` exception if validation failed.
  def validate_user_params
    form = EmailAndPasswordForm.new(organisations_params)
    return if form.valid?

    log_invalid_params(form.errors.full_messages)
    raise NewPasswordException, form.errors.messages
  end

  def perform_api_call
    # TO DO: TO be defined later
  end
end
