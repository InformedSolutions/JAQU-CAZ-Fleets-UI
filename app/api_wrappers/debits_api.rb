# frozen_string_literal: true

##
# API wrapper for connecting to Accounts API.
# Wraps methods regarding direct debits management.
# See {AccountsApi}[rdoc-ref:AccountsApi] for user related actions.
#
class DebitsApi < AccountsApi
  class << self
    #:nocov:
    # rubocop:disable Lint/UnusedMethodArgument
    def caz_mandates(account_id:, zone_id:)
      log_action("Getting CAZ mandates for account_id #{account_id} and zone_id: #{zone_id}")
      return { 'clearAirZones' => [] } unless $request.session[session_key]

      mocked_response('caz_mandates.json')

      # query = { 'cleanAirZoneId' => zone_id }
      # request(:get, "/accounts/#{account_id}/caz_mandates", query: query)
    end

    def create_payment(caz_id:, return_url:, user_id:, transactions:)
      log_action("Creating direct debit payment for user with id: #{user_id}")

      mocked_response('create_payment.json')

      # body = payment_creation_body(
      #   caz_id: caz_id,
      #   return_url: return_url,
      #   user_id: user_id,
      #   transactions: transactions
      # )
      # request(:post, '/direct-debit_payments', body: body.to_json)
    end

    def mandates(account_id:)
      log_action("Getting mandates for account with id: #{account_id}")

      if $request.session[session_key].present?
        mocked_response('active_mandates.json')['clearAirZones']
      else
        mocked_response('mandates.json')['clearAirZones']
      end

      # query = { 'cleanAirZoneId' => zone_id }
      # request(:get, "/accounts/#{account_id}/direct-debit-mandates", query: query)
    end

    def add_mandate(account_id:, zone_id:, return_url:)
      log_action("Adding a mandate for account with id: #{account_id} and zone id: #{zone_id}")
      return false unless $request

      $request.session[session_key] = true
      {
        'directDebitMandateId' => '5cd7441d-766f-48ff-b8ad-1809586fea37',
        'nextUrl' => return_url
      }
    end
    # rubocop:enable Lint/UnusedMethodArgument

    private

    def session_key
      'mocked_mandates'
    end

    def mocked_response(filename)
      JSON.parse(File.read("spec/fixtures/responses/debits/#{filename}"))
    end
  end
end
