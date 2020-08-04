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
<<<<<<< HEAD
    #
    def initialize(account_id)
      @account_id = account_id
=======
    # * +user_id+ - Account User ID from backend DB
    # * +user_payments+ - boolean, to filter out company payments and show only users payments
    #
    def initialize(account_id, user_id, user_payments)
      @account_id = account_id
      @user_id = user_id
      @user_payments = user_payments
>>>>>>> develop
    end

    # Returns a PaymentHistory::PaginatedPayment with payments associated with the account
    # Includes data about page and total pages count
    def pagination(page:)
      @pagination ||= begin
<<<<<<< HEAD
                   data = PaymentHistoryApi.payments(account_id: account_id, page: page)
=======
                   data = PaymentHistoryApi.payments(
                     account_id: account_id,
                     user_id: user_id,
                     user_payments: user_payments,
                     page: page
                   )
>>>>>>> develop
                   PaymentHistory::PaginatedPayment.new(data)
                 end
    end

    private

<<<<<<< HEAD
    # Reader for Account ID from backend DB
    attr_reader :account_id
=======
    # Attributes used internally
    attr_reader :account_id, :user_id, :user_payments
>>>>>>> develop
  end
end
