# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Controller used to show detailed information about the all company and users payments
  #
  class PaymentHistoryController < ApplicationController
    include CheckPermissions
    before_action -> { check_permissions(allow_view_payment_history?) }, only: :company_payment_history
    before_action -> { check_permissions(allow_make_payments?) }, only: :user_payment_history
    before_action -> { assign_paginated_history }, only: %i[company_payment_history user_payment_history]

    ##
    # Renders the company payment history page
    #
    # ==== Path
    #
    #    :GET /company_payment_history
    #
    def company_payment_history
      @back_button_url = determinate_back_link_url(
        :company_back_link_history,
        dashboard_url,
        company_payment_history_url
      )
    rescue BaseApi::Error400Exception
      return redirect_to company_payment_history_path unless page_number == 1
    end

    ##
    # Renders the user payment history page
    #
    # ==== Path
    #
    #    :GET /user_payment_history
    #
    def user_payment_history
      @back_button_url = determinate_back_link_url(
        :user_back_link_history,
        dashboard_url,
        user_payment_history_url
      )
    rescue BaseApi::Error400Exception
      return redirect_to user_payment_history_path unless page_number == 1
    end

    ##
    # Renders the payment details page
    #
    # ==== Path
    #
    #    :GET /payment_history_details
    #
    def payment_history_details; end

    private

    # Assign paginated history to variable
    def assign_paginated_history
      @pagination = PaymentHistory::History.new(current_user.account_id).pagination(page: page_number)
    end

    # page number from params
    def page_number
      (params[:page] || 1).to_i
    end

    # payment_id from params
    def payment_id
      params['payment_id']
    end

    # Returns back link url, e.g '.../company_payment_history?page=3?back=true'
    def determinate_back_link_url(session_key, default_url, url)
      BackLinkHistoryService.call(
        session: session,
        session_key: session_key,
        back_button: request.query_parameters['page']&.include?('back'),
        page: page_number,
        default_url: default_url,
        url: url
      )
    end
  end
end
