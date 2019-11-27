# frozen_string_literal: true

class AccountsApi
  class << self
    def sign_in(email:, password:)
      return false unless password == 'password'

      User.new(email: email, sub: SecureRandom.uuid)
    end
  end
end
