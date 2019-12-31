# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding user management.
# See {FleetsApi}[rdoc-ref:FleetsApi] for fleet related actions.
#
class AccountsApi < BaseApi
  base_uri ENV.fetch('ACCOUNTS_API_URL', 'localhost:3001') + '/v1'

  class << self
    def sign_in(email:, password:)
      raise BaseApi::Error401Exception.new(401, '', {}) unless password.include?('password')

      raise BaseApi::Error422Exception.new(422, '', {}) if email.include?('unconfirmed')

      {
        'email' => email,
        'accountUserId' => SecureRandom.uuid,
        'accountId' => SecureRandom.uuid,
        'accountName' => 'Royal Mail',
        'admin' => password == 'admin_password'
      }
    end

    def create_account(email:, password:, company_name:)
      log_action("Creating account with email: #{email} and company_name: #{company_name}")
      body = { accountName: company_name, email: email, password: password }.to_json
      user_data = request(:post, '/accounts', body: body)
      # Override for a dummy endpoint. Should be removed after proper backend implementation
      user_data['email'] = email
      user_data
    end

    def verify_user(account_id:, user_id:)
      log_action("Verifying account with account_id: #{account_id} and user_id: #{user_id}")
      request(:post, "/accounts/#{account_id}/users/#{user_id}/verify")
    end
  end
end
