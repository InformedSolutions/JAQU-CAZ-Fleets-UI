# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/users/new.html.haml+.
class NewUserForm < BaseForm
  # Attribute used internally
  attr_accessor :name, :email_address

  # validates attributes to presence
  validates :name, :email_address, presence: {
    message: I18n.t('input_form.errors.missing')
  }

  # validates max length
  validates :name, :email_address, length: {
    maximum: 45,
    message: I18n.t('input_form.errors.maximum_length')
  }

  # validates email format
  validates :email_address, format: {
    with: EMAIL_FORMAT,
    message: I18n.t('input_form.errors.invalid_format')
  }
end
