# frozen_string_literal: true

module Encryption
  # Service used to decrypt token
  #
  # ==== Usage
  #    token = { user_id: 5 }
  #    encrypted_token = Encryption::Encrypt.call(value: token)
  #    Encryption::Decrypt.call(value: encrypted_token)
  #    # { user_id: 5 }
  #
  class Decrypt < Base
    # Instance level .call method used by class level .call
    def call
      encryptor.decrypt_and_verify(value)
    end
  end
end
