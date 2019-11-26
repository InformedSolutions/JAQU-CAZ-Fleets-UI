# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/organisation_accounts/new_email_and_password.html.haml+.
class EmailAndPasswordForm
  # allow using ActiveRecord validation
  include ActiveModel::Validations

  # Attribute used internally
  attr_accessor :email, :email_confirmation, :password, :password_confirmation

  # rubocop:disable Style/FormatStringToken:
  # validates attributes to presence
  validates :email, :email_confirmation, :password, :password_confirmation,
            presence: { message: '%{attribute} is required' }

  # validates max length
  validates :email, :email_confirmation, :password, :password_confirmation,
            length: { maximum: 45, message: '%{attribute} is too long (maximum is 45 characters)' }

  # validates email format
  validates :email, :email_confirmation, format: {
    with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: '%{attribute} is in an invalid format'
  }

  # validates password and password_confirmation complexity
  validates :password, :password_confirmation, format: {
    with: /\A(?=.*?[A-Z])(?=.*?[a-z])(?=(.*[\W])+)(?!.*\s).{8,45}\z/,
    message: '%{attribute} must be at least 8 characters long, include at least one upper case
      letter, a number and a special character'
  }
  # rubocop:enable Style/FormatStringToken:

  # validates +password+ and +password_confirmation+
  validate :correct_password_confirmation
  # validates +email+ and +email_confirmation+
  validate :correct_email_confirmation

  # Checks if +password+ and +password_confirmation+ are same.
  # If not, add error message to +password+. and +password_confirmation+
  def correct_password_confirmation
    return if password == password_confirmation

    error_message = I18n.t('password.errors.password_equality')
    errors.add(:password, :invalid, message: error_message)
    errors.add(:password_confirmation, :invalid, message: error_message)
  end

  # Checks if +email+ and +email_confirmation+ are same.
  # If not, add error message to +email+. and +email_confirmation+
  def correct_email_confirmation
    return if email == email_confirmation

    error_message = I18n.t('email.errors.email_equality')
    errors.add(:email, :invalid, message: error_message)
    errors.add(:email_confirmation, :invalid, message: error_message)
  end

  # Overrides default initializer for compliance with form_for method in content_form view
  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  # Used in email_and_password form view and should return nil when the object is not persisted.
  def to_key
    nil
  end
end
