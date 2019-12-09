# frozen_string_literal: true

##
# Service used to verify account, call verify endpoint in the backend API
#
# ==== Usage
#    VerifyAccount.call(token: params[:token])
#
class VerifyAccount < BaseService
  # Initializer method used by class level +.call+ method
  #
  # ==== Attributes
  # * +token+ - string, encrypted token containing user related information like +user_id+
  #
  def initialize(token:)
    @encrypted_token = token
  end

  # Execution method used by class level +.call+ method.
  # It decrypts the token and performs API call.
  #
  # It return true if both actions were successful, and false if something fails.
  #
  def call
    verify_user
    true
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    Rails.logger.error "[#{self.class.name}] Invalid token - #{encrypted_token}"
    false
  rescue ApiException => e
    log_error(e)
    false
  end

  private

  # Performs the API call to verification endpoint
  def verify_user
    AccountsApi.verify_user(
      _account_id: decrypted_token[:account_id],
      _user_id: decrypted_token[:user_id]
    )
  end

  # Decrypts the token
  def decrypted_token
    @decrypted_token ||= Encryption::Decrypt.call(value: encrypted_token)
  end

  # Reader function for encrypted token
  attr_reader :encrypted_token
end
