# frozen_string_literal: true

class AccountsApi
  class << self
    def sign_in(email:, password:)
      if password == 'password'
        User.new(email: email, sub: SecureRandom.uuid)
      elsif password == 'admin_password'
        User.new(email: email, sub: SecureRandom.uuid, admin: true)
      else
        false
      end
    end
  end
end
