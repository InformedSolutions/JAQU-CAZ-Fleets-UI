# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/users/set_up.html.haml+.
class SetUpAccountForm < NewUserBaseForm
  validates :password,
            presence: { message: I18n.t('email_and_password_form.password_missing') }

  validates :password_confirmation,
            presence: { message: I18n.t('email_and_password_form.password_confirmation_missing') }

  validate :correct_password_confirmation?

  ##
  # Initializes the form
  #
  # ==== Attributes
  # * +params+ - request parameters
  #
  def initialize(params:)
    @token = params[:token]
    @password = params[:password]
    @password_confirmation = params[:password_confirmation]
  end

  # Submits the form - sets user password
  def submit
    set_up_account_api_call
  end

  private

  attr_reader :token, :password, :password_confirmation

  # API request to set user password
  def set_up_account_api_call
    AccountsApi.set_password(token: token, password: password)
  rescue BaseApi::Error400Exception
    errors.add(:token, :invalid, message: I18n.t('token_form.token_invalid'))
    false
  rescue BaseApi::Error422Exception
    errors.add(:password, :invalid,
               message: I18n.t('new_password_form.errors.password_complexity'))
    errors.add(:password_confirmation, :invalid,
               message: I18n.t('new_password_form.errors.password_complexity'))
    false
  end

  # Checks if +password+ and +password_confirmation+ are same.
  # If not, add error message to +password+. and +password_confirmation+
  def correct_password_confirmation?
    return if password == password_confirmation

    equality_error_message = I18n.t('new_password_form.errors.password_not_equal')
    errors.add(:password, :invalid, message: equality_error_message)
    errors.add(:password_confirmation, :invalid, message: equality_error_message)
  end
end
