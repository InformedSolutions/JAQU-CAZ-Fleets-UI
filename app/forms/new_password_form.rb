# frozen_string_literal: true

##
# Class used to validate form rendered on the +app/views/passwords/index.html.haml+
class NewPasswordForm < BaseForm
  attr_accessor :password, :password_confirmation

  validates :password, presence: { message: I18n.t('password.errors.password_required') }
  validates :password_confirmation,
            presence: { message: I18n.t('password.errors.confirmation_required') }

  validate :correct_password_confirmation

  # Checks if +password+ and +password_confirmation+ are same.
  # If not, add error message to +password+. and +password_confirmation+
  def correct_password_confirmation
    return if password == password_confirmation

    error_message = I18n.t('password.errors.password_equality')
    errors.add(:password, :invalid, message: error_message)
    errors.add(:password_confirmation, :invalid, message: error_message)
  end
end
