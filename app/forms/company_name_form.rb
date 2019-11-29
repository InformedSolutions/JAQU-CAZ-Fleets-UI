# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/organisation_accounts/new_name.html.haml+.
class CompanyNameForm < BaseForm
  # Attribute used internally
  attr_accessor :company_name

  # validates attributes to presence
  validates :company_name, presence: { message: I18n.t('form.errors.missing') }

  # validates max length
  validates :company_name, length: {
    maximum: 100, message: I18n.t('form.errors.maximum_length', length: 100)
  }
end
