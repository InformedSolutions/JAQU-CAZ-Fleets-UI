# frozen_string_literal: true

class AccountsApi < BaseApi
  base_uri ENV.fetch('ACCOUNTS_API_URL', 'localhost:3001') + '/v1'

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => -> { SecureRandom.uuid }
  )

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

    def fleet_vehicles(_account_id:)
      return [] unless $request

      $request.session['mocked_fleet'] || []
    end

    def add_vehicle_to_fleet(details:, _account_id:)
      return false unless $request

      fleet = $request.session['mocked_fleet'] || []
      unless fleet.any? { |vehicle| vehicle['vrn'] == details[:vrn] }
        fleet.push(mocked_new_vehicle(details))
      end
      $request.session['mocked_fleet'] = fleet
      true
    end

    private

    def mocked_new_vehicle(details)
      {
        'vehicleId' => SecureRandom.uuid,
        'vrn' => details[:vrn],
        'type' => details[:type] || 'car',
        'charges' => {
          'leeds' => details[:leeds_charge] || 12.5,
          'birmingham' => details[:birmingham_charge] || 8
        }
      }
    end
  end
end
