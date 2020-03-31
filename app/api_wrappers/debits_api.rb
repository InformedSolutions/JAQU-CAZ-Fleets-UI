# frozen_string_literal: true

##
# API wrapper for connecting to Payments API.
# Wraps methods regarding direct debits management.
# See {PaymentsApi}[rdoc-ref:PaymentsApi] for user related actions.
#
class DebitsApi < PaymentsApi
  class << self
    include DebitsApiResponses
    #:nocov:
    # rubocop:disable Lint/UnusedMethodArgument
    def caz_mandates(account_id:, zone_id:)
      log_action("Getting CAZ mandates for account_id #{account_id} and zone_id: #{zone_id}")

      return [] unless $request && $request.session[session_key]

      caz_mandates_response['mandates']

      # request(
      #   :get,
      #   "payments/accounts/#{account_id}/direct-debit-mandates/#{zone_id}"
      # )['mandates']
    end

    def create_payment(caz_id:, user_id:, transactions:)
      log_action("Creating direct debit payment for user with id: #{user_id}")

      create_payment_response

      # body = payment_creation_body(
      #   caz_id: caz_id,
      #   user_id: user_id,
      #   transactions: transactions
      # )
      # request(:post, 'payments/direct-debit-mandates', body: body.to_json)
    end

    def mandates(account_id:)
      log_action("Getting mandates for account with id: #{account_id}")

      if $request && $request.session[session_key]
        active_mandates_response['clearAirZones']
      else
        mandates_response['clearAirZones']
      end

      # request(:get, "payments/accounts/#{account_id}/direct-debit-mandates")['clearAirZones']
    end

    def create_mandate(account_id:, zone_id:, return_url:)
      log_action("Adding a mandate for account with id: #{account_id} and zone id: #{zone_id}")

      $request.session[session_key] = true
      {
        'nextUrl' => return_url,
        'cleanAirZoneId' => '3fa85f64-5717-4562-b3fc-2c963f66afa6'
      }
      # request(:post, "payments/accounts/#{account_id}/direct-debit-mandates")
    end
    # rubocop:enable Lint/UnusedMethodArgument

    private

    def session_key
      'mocked_mandates'
    end

    # Returns parsed JSON of the payment creation parameters with proper keys
    def payment_creation_body(caz_id:, user_id:, transactions:)
      {
        clean_air_zone_id: caz_id,
        user_id: user_id,
        transactions: transactions
      }.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end
  end
end
