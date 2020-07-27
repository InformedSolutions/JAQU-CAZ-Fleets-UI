# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Controller used to show detailed information about the all company and users payments
  #
  class PaymentHistoryController < ApplicationController
    include CheckPermissions
    before_action -> { check_permissions(allow_view_payment_history?) }, only: %(company_payment_history)
    before_action -> { check_permissions(allow_make_payments?) }, only: %(user_payment_history)

    ##
    # Renders the company payment history page
    #
    # ==== Path
    #
    #    :GET /company_payment_history
    #
    def company_payment_history; end

    ##
    # Renders the user payment history page
    #
    # ==== Path
    #
    #    :GET /user_payment_history
    #
    def user_payment_history; end
  end
end
