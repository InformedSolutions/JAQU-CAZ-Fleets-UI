# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # This class is used to validate company name filled in +app/views/account_details/primary_users/edit_name.html.haml+
  class EditCompanyNameForm < Organisations::CompanyNameForm
    # Attribute used internally
    attr_accessor :account_id    

    # Performs company name update by calling +/v1/accounts/:accountId+
    # Handles api 422 error
    def submit
      AccountsApi.update_company_name(account_id: account_id, company_name: company_name)
    rescue BaseApi::Error422Exception => e
      parse_422_error(e.body['errorCode'])
      false
    end

    private

    # Handles api 422 errors. Assigns error messages to error object depending on error enum
    def parse_422_error(enum)
      case enum
      when 'duplicate'
        errors.add(:company_name, :invalid, message: I18n.t('company_name.errors.duplicate'))
      when 'profanity'
        errors.add(:company_name, :invalid, message: I18n.t('company_name.errors.profanity'))
      when 'abuse'
        errors.add(:company_name, :invalid, message: I18n.t('company_name.errors.abuse'))
      else
        errors.add(:company_name, :invalid, message: 'Something went wrong')
      end
    end
  end
end
