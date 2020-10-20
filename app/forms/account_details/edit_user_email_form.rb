# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # This class is used to validate users email filled in +app/views/account_details/primary_users/edit_email.html.haml+
  class EditUserEmailForm < BaseForm
    # Attributes accessor
    attr_accessor :account_id, :email

    # validates +email+ presence
    validates :email, presence: { message: I18n.t('edit_user_email_form.errors.email_missing') }

    # validates +email+ format
    validates :email, format: {
      with: EMAIL_FORMAT,
      message: I18n.t('edit_user_email_form.errors.email_invalid_format')
    }, allow_blank: true

    # validates +email+ against duplication
    validate :email_not_duplicated, if: -> { email.present? }

    private

    # Checks if +email+ are unique.
    # If not, add error message to +email+.
    def email_not_duplicated
      return if email_unique?

      error_message = I18n.t('edit_user_email_form.errors.email_duplicated')
      errors.add(:email, :invalid, message: error_message)
    end

    # Checks if email is unique
    def email_unique?
      AccountsApi::Accounts.user_validations(account_id: account_id, name: email, email: email)
      true
    rescue BaseApi::Error400Exception => e
      log_error(e)
      false
    end
  end
end
