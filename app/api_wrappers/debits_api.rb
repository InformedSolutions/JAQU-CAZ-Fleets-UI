# frozen_string_literal: true

##
# API wrapper for connecting to Payments API.
# Wraps methods regarding Direct Debits management.
# See {PaymentsApi}[rdoc-ref:PaymentsApi] for user related actions.
#
class DebitsApi < PaymentsApi
  class << self
    ##
    # Calls +/v1/payments/accounts/:account_id/direct-debit-mandates/:zone_id+ endpoint with +GET+ method
    # and returns a list of account's Direct Debit mandates assigned to selected Clean Air Zone.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +zone_id+ - requested page of the results
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +mandates+ - array, list of the mandates
    #   * +id+ - uuid, mandate ID
    #   * +status+ - string, status of the mandate eg. 'active'
    #
    def caz_mandates(account_id:, zone_id:)
      log_action("Getting CAZ mandates for account_id #{account_id} and zone_id: #{zone_id}")

      request(
        :get,
        "/payments/accounts/#{account_id}/direct-debit-mandates/#{zone_id}"
      )['mandates']
    end

    ##
    # Calls +/v1/payments/direct-debit-payments+ endpoint with +POST+ method
    # which triggers the payment creation and returns details of the payment.
    #
    # ==== Attributes
    #
    # * +caz_id+ - ID of the selected CAZ
    # * +account_id+ - ID of the account associated with the fleet
    # * +user_id+ - ID of the users account from which the payment is being done.
    # * +mandate_id+ - ID of active mandate
    # * +transactions+ - array of objects
    #   * +vrn+ - Vehicle registration number
    #   * +travel_date+ - Date of the single transaction
    #   * +tariff_code+ - tariff code used for calculations
    #   * +charge+ - transaction charge value (daily charge)
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +paymentId+ - uuid, ID of the payment created in GovUK.Pay
    # * +referenceNumber+ - integer, central reference number of the payment
    # * +externalPaymentId+ - string, external identifier for the payment
    #
    def create_payment(caz_id:, account_id:, user_id:, mandate_id:, transactions:)
      log_action("Creating Direct Debit payment for user with id: #{user_id}")

      body = payment_creation_body(
        caz_id: caz_id,
        account_id: account_id,
        user_id: user_id,
        mandate_id: mandate_id,
        transactions: transactions
      )
      request(:post, '/direct-debit-payments', body: body.to_json)
    end

    ##
    # Calls +/v1/payments/accounts/:account_id/direct-debit-mandates+ endpoint with +GET+ method
    # and returns a list of clean air zones with the associated Direct Debit mandates.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    #
    # ==== Result
    #
    # Returned vehicles details will have the following fields:
    # * +cleanAirZones+ - array, list of the CAZ's
    #   * +cazId+ - uuid, CleanAirZone ID
    #   * +cazName+ - string, name of the CAZ
    #   * +mandates+ - array, list of the mandates
    #     * +id+ - uuid, mandate ID
    #     * +status+ - string, status of the mandate eg. 'active'
    #
    def mandates(account_id:)
      log_action("Getting mandates for account with id: #{account_id}")

      request(:get, "/payments/accounts/#{account_id}/direct-debit-mandates")['cleanAirZones']
    end

    ##
    # Calls +/v1/payments/accounts/:account_id/direct-debit-mandates+ endpoint with +POST+ method
    # which triggers the Direct Debit creation and returns hash with +nextUrl+.
    #
    # ==== Attributes
    #
    # * +account_id+ - ID of the account associated with the fleet
    # * +caz_id+ - uuid, ID of the CAZ
    # * +return_url+ - URL where GOV.UK Pay should redirect after the payment is done.
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +nextUrl+ - string, path where user should be redirected
    #
    def create_mandate(account_id:, caz_id:, return_url:)
      log_action("Adding a mandate for account with id: #{account_id} and zone id: #{caz_id}")

      body = {
        cleanAirZoneId: caz_id,
        returnUrl: return_url
      }.to_json

      request(:post, "/payments/accounts/#{account_id}/direct-debit-mandates", body: body)
    end

    private

    # Returns parsed JSON of the payment creation parameters with proper keys
    def payment_creation_body(account_id:, caz_id:, user_id:, mandate_id:, transactions:)
      {
        account_id: account_id,
        clean_air_zone_id: caz_id,
        user_id: user_id,
        mandate_id: mandate_id,
        transactions: transactions
      }.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end
  end
end
