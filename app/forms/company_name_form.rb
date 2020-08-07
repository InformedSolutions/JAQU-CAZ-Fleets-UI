# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/organisation_accounts/new_name.html.haml+.
class CompanyNameForm < BaseForm
  # Attribute used internally
  attr_accessor :company_name

  COMPANY_NAME_REGEX = %r{(^$|^[[:alpha:][0-9] /'\-&.]+)$}u.freeze
  MAX_COMPANY_NAME_LENGTH = 180

  # validates attributes to presence
  validates :company_name, presence: { message: I18n.t('company_name_form.comapny_name_missing') }

  # validates max length
  validates :company_name, length: {
    maximum: MAX_COMPANY_NAME_LENGTH,
    too_long: I18n.t('company_name_form.company_name_invalid_length')
  }

  # validates format
  validates :company_name, format: {
    with: COMPANY_NAME_REGEX,
    multiline: true,
    message: I18n.t('company_name_form.company_name_invalid_format')
  }
end
