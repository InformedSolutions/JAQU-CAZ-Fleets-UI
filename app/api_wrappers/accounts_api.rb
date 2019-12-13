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
      log_action("Creating account with email: #{email} and company_name: #{company_name}")
      body = { accountName: company_name, email: email, password: password }.to_json
      request(:post, '/accounts', body: body)
    end

    def verify_user(account_id:, user_id:)
      log_action("Verifying account with account_id: #{account_id} and user_id: #{user_id}")
      request(:post, "/accounts/#{account_id}/users/#{user_id}/verify")
    end

    def fleet_vehicles(_account_id:)
      return [] unless $request

      $request.session['mocked_fleet'] || []
    end

    def add_vehicle_to_fleet(details:, _account_id:) # rubocop:disable Metrics/MethodLength
      return false unless $request

      fleet = $request.session['mocked_fleet'] || []
      fleet.push(
        'vehicleId' => SecureRandom.uuid,
        'vrn' => details[:vrn],
        'type' => details[:type] || 'car',
        'charges' => {
          'leeds' => details[:leeds_charge] || 12.5,
          'birmingham' => details[:birmingham_charge] || 8
        }
      )
      $request.session['mocked_fleet'] = fleet
      true
    end
  end
end
