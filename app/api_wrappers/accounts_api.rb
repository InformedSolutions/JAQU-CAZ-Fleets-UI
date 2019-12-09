# frozen_string_literal: true

class AccountsApi
  class << self
    def sign_in(email:, password:)
      user_details = { email: email, user_id: SecureRandom.uuid, account_id: SecureRandom.uuid }
      if password == 'password'
        User.new(user_details)
      elsif password == 'admin_password'
        User.new(user_details.merge(admin: true))
      else
        false
      end
    end

    def create_organization(email:, _password:, _company_name:)
      User.new(
        email: email,
        user_id: SecureRandom.uuid,
        account_id: SecureRandom.uuid,
        admin: true
      )
    end

    def verify_user(_account_id:, _user_id:)
      true
    end
  end
end
