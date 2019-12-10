# frozen_string_literal: true

class AccountsApi < BaseApi
  base_uri ENV.fetch('ACCOUNTS_API_URL', 'localhost:3001') + '/v1'

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => -> { SecureRandom.uuid }
  )

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

    def create_account(email:, password:, company_name:)
      log_action("Creating account with email: #{email}, and company_name #{company_name}")
      body = { accountName: company_name, email: email, password: password }.to_json
      request(:post, '/accounts', body: body)
    end

    def verify_user(_account_id:, _user_id:)
      true
    end
  end
end
