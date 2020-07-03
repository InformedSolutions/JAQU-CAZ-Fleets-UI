# frozen_string_literal: true

##
# This class is used to validate user data filled in
# +app/views/users/new.html.haml+ and +app/views/users/add_permissions.html.haml+.
class NewUserBaseForm < BaseForm
  # validates +email+ against duplication
  validate :email_not_duplicated, if: -> { email.present? }

  attr_reader :email_duplicated

  private

  attr_reader :account_id, :name, :email

  # Checks if +email+ are unique.
  # If not, add error message to +email+.
  def email_not_duplicated
    return if email_unique?

    @email_duplicated = true
    error_message = I18n.t('add_new_user_form.errors.email_duplicated')
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
