# frozen_string_literal: true

##
# API wrapper for connecting to AccountsApi.
# Wraps methods regarding payment history.
module AccountsApi
  ##
  # API wrapper for connecting to Accounts API - Payment history endpoints
  #
  class PaymentHistory < Base
    class << self
      ##
      # Calls +/v1/accounts/:accountId/payment-history-export+ endpoint with +POST+ method and returns
      # an empty body response.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, id of the account
      # * +recipient_id+ - uuid, id of the user who is going to receive an email
      # * +filtered_user_id+ - uuid, id of the user whose payments are going to be exported
      #
      # ==== Result
      #
      #   Returns an empty body
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def payment_history_export(account_id:, recipient_id:, filtered_user_id: nil)
        log_action('Initiating payment history download')
        body = { recipientAccountUserId: recipient_id }
        body.merge!(filteredPaymentsForAccountUserId: filtered_user_id) if filtered_user_id

        request(:post, "/accounts/#{account_id}/payment-history-export", body: body.to_json)
      end

      ##
      # Calls +/v1/accounts/:accountId/payment-history-export/{jobId} endpoint with +GET+ method.
      #
      # ==== Attributes
      #
      # * +account_id+ - uuid, id of the account
      # * +job_id+ - uuid, id of the CSV processing job
      #
      # ==== Result
      #
      # Returned vehicles details will have the following fields:
      # * +recipientAccountUserId+ - uuid, ID of the account user who initiated the download
      # * +fileUrl+ - string, pre-signed S3 URL to a file
      # * +status+ - string, status of the job
      #
      # ==== Exceptions
      #
      # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - account not found
      # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
      #
      def payment_history_export_status(account_id:, job_id:)
        log_action('Getting the CSV processing job status')
        request(:get, "/accounts/#{account_id}/payment-history-export/#{job_id}")
      end
    end
  end
end
