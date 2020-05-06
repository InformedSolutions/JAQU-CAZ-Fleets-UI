# frozen_string_literal: true

##
# Service used to validate company name and throw exception if is not valid.
#
class CheckCompanyName < BaseService
  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +company_name+ - string, the company name submitted by the user
  #
  def initialize(company_name:)
    @company_name = company_name
  end

  ##
  # The caller method for the service.
  # Invokes validation for company name format and performs a request to API.
  # When response is other than :created (201) then throws an exception.
  def call
    form = CompanyNameForm.new(company_name: company_name)
    return if form.valid?

    error_message = form.errors.full_messages.first
    log_invalid_params(error_message)
    raise InvalidCompanyNameException, error_message
  end

  private

  attr_reader :company_name
end
