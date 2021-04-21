# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Class responsible for performing an API call to initiate payment history download
  # process based on the probided parameters
  class InitiatePaymentHistoryExport < BaseService
    ##
    # Initializer method
    #
    # ==== Attributes
    #
    # * +user+ - user object
    # * +filtered_export+ - boolean
    #
    def initialize(user:, filtered_export: false)
      @user = user
      @filtered_export = filtered_export
    end

    # Performs an API call with proper parameters
    def call
      return initiate_export_for_filtered_users if filtered_export

      initiate_export_for_all_users
    end

    private

    attr_reader :user, :filtered_export

    # Fetches account_id from user object
    def account_id
      user.account_id
    end

    # Fetches recipient_id from user object
    def recipient_id
      user.user_id
    end

    # Performs an API call to initiate payment history download for selected user
    # from an organisation.
    def initiate_export_for_filtered_users
      PaymentHistoryApi.payment_history_export(
        account_id: account_id,
        recipient_id: recipient_id,
        filtered_user_id: recipient_id
      )
    end

    # Performs an API call to initiate payment history download for all users
    # from an organisation.
    def initiate_export_for_all_users
      PaymentHistoryApi.payment_history_export(
        account_id: account_id,
        recipient_id: recipient_id
      )
    end
  end
end
