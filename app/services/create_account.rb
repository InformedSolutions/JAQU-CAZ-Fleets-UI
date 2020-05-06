# frozen_string_literal: true

##
# Service used to validate company name and perform request to API which creates the Company.
#
class CreateAccount < BaseService
  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +company_name+ - string, the company name submitted by the user
  # * +confirm_fleet_check+ - string, fleet_check choosen by user
  #
  def initialize(company_name:, confirm_fleet_check:)
    @company_name = company_name
    @confirm_fleet_check = confirm_fleet_check
  end

  ##
  # The caller method for the service.
  # Invokes validation for company name format and performs a request to API.
  # When response is other than :created (201) then throws an exception.
  def call
    validate_params
    fleet_check
    created_account_data = perform_api_call

    created_account_data['accountId']
  end

  private

  attr_reader :company_name, :confirm_fleet_check

  def validate_params
    form = CreateAccountForm.new(company_name: company_name,
                                 confirm_fleet_check: confirm_fleet_check)
    return if form.valid?

    error_message = form.errors.full_messages.first
    log_invalid_params(error_message)
    raise InvalidCompanyCreateException, error_message
  end

  def fleet_check
    raise AccountForMultipleVehiclesException if confirm_fleet_check == 'less_than_two'
  end

  def perform_api_call
    AccountsApi.create_account(company_name: company_name)
  rescue BaseApi::Error422Exception => e
    parse_422_error(e.body['errorCode'])
  end

  # Check if api returns 422 errors. If yes assign error messages to error object and
  # raise `UnableToCreateAccountException` exception
  def parse_422_error(enum)
    error = if enum.eql?('duplicate')
              I18n.t('company_name.errors.duplicate')
            elsif enum.eql?('profanity')
              I18n.t('company_name.errors.profanity')
            elsif enum.eql?('abuse')
              I18n.t('company_name.errors.abuse')
            end

    log_invalid_params(error)
    raise UnableToCreateAccountException, error
  end
end
