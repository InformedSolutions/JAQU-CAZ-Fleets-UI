# frozen_string_literal: true

##
# API wrapper for connecting to PaymentsApi.
# Wraps methods regarding payment history.
# See {PaymentsApi}[rdoc-ref:PaymentsApi] for user related actions.
#
class PaymentHistoryApi < PaymentsApi
  class << self
    ##
    # Calls +/v1/accounts/:accountId/payments+ endpoint with +GET+ method and returns payment history
    #
    # ==== Attributes
    #
    # * +account_id+ - uuid, id of the account
<<<<<<< HEAD
=======
    # * +user_id+ - uuid, ID of the user
    # * +user_payments+ - boolean, to filter out company payments and show only users payments
>>>>>>> develop
    #
    # ==== Result
    #
    # Returned payment history will have the following fields:
    # * +payments+ - list of payment history
    # * +perPage+ - requested per_page value
    # * +page+ - requested page value
    # * +pageCount+ - number of available pages
    # * +totalPaymentsCount+ - total number of payment histories
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
<<<<<<< HEAD
    def payments(account_id:, page: 1)
      log_action 'Getting payments history'
      query = { 'pageNumber' => calculate_page_number(page), 'pageSize' => 10 }
=======
    def payments(account_id:, user_id:, user_payments:, page: 1)
      log_action 'Getting payments history'
      query = { 'pageNumber' => calculate_page_number(page), 'pageSize' => 10 }
      query.merge!('accountUserId' => user_id) if user_payments
>>>>>>> develop
      request(:get, "/accounts/#{account_id}/payments", query: query)
    end

    ##
<<<<<<< HEAD
    # Calls +/v1/payments/:paymentId+ endpoint with +GET+ method and returns payment history
=======
    # Calls +/v1/payments/:paymentId+ endpoint with +GET+ method and returns detailed payment history
>>>>>>> develop
    #
    # ==== Attributes
    #
    # * +payment_id+ - uuid, id of payment
    #
    # ==== Result
    #
    # Returned payment history will have the following fields:
<<<<<<< HEAD
=======
    # * +payerName+ - payment made by
>>>>>>> develop
    # * +centralPaymentReference+ - unique traceability identifier
    # * +paymentDate+ - payment date
    # * +paymentProviderId+ - id of provider
    # * +totalPaid+ - amount of payment
    # * +telephonePayment+ - status of payment
    # * +lineItems+* - array of objects
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - payment not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
<<<<<<< HEAD
    def payment(payment_id:)
=======
    def payment_details(payment_id:)
>>>>>>> develop
      log_action 'Getting payment history'
      request(:get, "/payments/#{payment_id}")
    end
  end
end
