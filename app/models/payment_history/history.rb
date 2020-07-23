# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Represents the virtual model of the payment history
  #
  class History
    # Initializer method.
    #
    # ==== Params
    # * +account_id+ - Account ID from backend DB
    #
    def initialize(account_id)
      @account_id = account_id
    end

    # Returns a PaymentHistory::PaginatedPayment with payments associated with the account
    # Includes data about page and total pages count
    def pagination(page:)
      @pagination ||= begin
                   data = PaymentHistoryApi.payments(account_id: account_id, page: page)
                   PaymentHistory::PaginatedPayment.new(data)
                 end
    end

    private

    # Reader for Account ID from backend DB
    attr_reader :account_id
  end
end
