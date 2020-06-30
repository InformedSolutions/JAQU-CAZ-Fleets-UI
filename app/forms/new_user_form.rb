# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/users/new.html.haml+.
class NewUserForm < BaseForm

  # validates email format
  validates :email, format: {
    with: EMAIL_FORMAT,
    message: I18n.t('input_form.errors.invalid_format')
  }, allow_blank: true

  # validates name attribute to presence
  validates :name, presence: { message: I18n.t('add_user_form.errors.name_missing') }

  # validates name attribute to presence
  validates :email, presence: { message: I18n.t('add_user_form.errors.email_missing') }

  # validates +email+ and +email_confirmation+
  validate :email_not_duplicated, if: lambda { email.present? }

  ##
  # Initializes the form
  #
  # ==== Attributes
  # * +account_id+ - uuid, the id of the administrator user account
  # + +user_params+ - array, user params: email and name
  #
  def initialize(account_id, user_params)
    @account_id = account_id
    @name = user_params[:name]
    @email = user_params[:email]
  end

  private

  attr_reader :account_id, :name, :email

  # Checks if +email+ are unique.
  # If not, add error message to +email+.
  def email_not_duplicated
    return if email_unique?

    error_message = I18n.t('add_user_form.errors.email_duplicated')
    errors.add(:email, :invalid, message: error_message)
  end

  # Checks if email is unique
  def email_unique?
    AccountsApi.user_validations(account_id: account_id, name: name, email: email)
    true
  rescue ApiException => e
    log_error(e)
    false
  end

  # Logs exception on +error+ level
  def log_error(exception)
    Rails.logger.error "[#{self.class.name}] #{exception.class} - #{exception}"
  end
end
