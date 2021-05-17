# frozen_string_literal: true

##
# Module used for showing the payment history
module PaymentHistory
  ##
  # Controller used to show detailed information about the all company and users payments
  #
  class PaymentHistoryController < ApplicationController # rubocop:disable Metrics/ClassLength
    include CheckPermissions

    before_action lambda {
      check_permissions(allow_view_details_history?)
    }, except: %i[payment_history]

    ##
    # Renders the payment history page
    #
    # ==== Path
    #
    #    :GET /payment_history
    #
    def payment_history
      check_history_permissions
      @back_button_url = determinate_back_link_url
    rescue BaseApi::Error400Exception
      return redirect_to payment_history_path unless page_number == 1
    end

    ##
    # Renders the payment details page
    #
    # ==== Path
    #
    #    :GET /payment_history_details
    #
    def payment_history_details
      @details =  PaymentHistory::Details.new(payment_id)
      @payments = @details.payments
      @payment_modifications = @details.payment_modifications
      @back_button_url = determinate_back_link
    end

    ##
    # Performs an API call to initiate the payment history download process.
    #
    # ==== Path
    #
    #    :GET /initiate_payment_history_download
    #
    def initiate_payment_history_download
      PaymentHistory::InitiatePaymentHistoryExport.call(
        user: current_user,
        filtered_export: !allow_view_payment_history?
      )

      redirect_to payment_history_downloading_path
    end

    ##
    # Renders the information about starting download of payments history.
    #
    # ==== Path
    #
    #    :GET /payment_history_downloading
    #
    def payment_history_downloading
      # renders static page
    end

    ##
    # Renders the page to allow a user to download a payments history file.
    #
    # ==== Path
    #
    #    :GET /payment_history_download
    #
    def payment_history_download
      @file_url = session[:payment_history_file_url]
      @file_name = session[:payment_history_file_name]
    end

    ##
    # Renders the page informing about expired URL.
    #
    # ==== Path
    #
    #   :GET /payment_history_link_expired
    #
    def payment_history_link_expired
      # renders a static page
    end

    ##
    # Renders the page informing that user doesn't have access to view the link.
    #
    # ==== Path
    #
    #   :GET /payment_history_link_no_access
    #
    def payment_history_link_no_access
      # renders a static page
    end

    # Performs an API call to check the validity of the download URL and redirects accordingly.
    #
    # ==== Path
    #
    #   :GET /payment_history_export?exportId=87252eee-e861-4619-891e-30045908286c
    #
    def handle_payment_history_download_link
      service = assign_export_status_service
      if !service.link_accessible_for?(current_user)
        redirect_to payment_history_link_no_access_path
      elsif !service.link_active?
        redirect_to payment_history_link_expired_path
      else
        store_file_details_in_session(service)
        redirect_to payment_history_download_path
      end
    end

    # Performs an API call to check the validity of the download URL and send file.
    #
    # ==== Path
    #
    #   :GET /payment_history_export_download?exportId=87252eee-e861-4619-891e-30045908286c
    #
    def handle_payment_history_download_attempt
      service = assign_export_status_service
      unless service.link_accessible_for?(current_user) && service.link_active?
        return redirect_back(fallback_location: payment_history_download_path)
      end

      send_data service.file_body.read, filename: service.file_url, type: service.file_content_type
    end

    private

    # Checks permissions and assigns paginated payment history
    def check_history_permissions
      if allow_view_payment_history?
        assign_paginated_history
      elsif allow_make_payments?
        assign_paginated_history(user_payments: true)
      else
        Rails.logger.warn('Access Denied. Redirects to :not_found page')
        redirect_to not_found_path
      end
    end

    # Assign paginated history to variable
    def assign_paginated_history(user_payments: false)
      @pagination = PaymentHistory::History.new(
        current_user.account_id, current_user.user_id, user_payments
      ).pagination(page: page_number, per_page: per_page)
    end

    # Assign Export status service to variable
    def assign_export_status_service
      PaymentHistory::ExportStatus.new(
        account_id: current_user.account_id, job_id: export_id
      )
    end

    # page number from params
    def page_number
      (params[:page] || 1).to_i
    end

    # per page size from params
    def per_page
      (params[:per_page] || 10).to_i
    end

    # payment_id from params
    def payment_id
      params['payment_id']
    end

    # export_id from params
    def export_id
      params['exportId']
    end

    # Returns back link url, e.g '.../company_payment_history?page=3?back=true'
    def determinate_back_link_url
      PaymentHistory::BackLinkHistory.call(
        session: session,
        back_button: request.query_parameters['page']&.include?('back'),
        page: page_number,
        default_url: dashboard_url,
        url: payment_history_url
      )
    end

    # Returns back link url on the payment history details page
    # Assign +company_payment_history+ and +payment_details_back_link+ to the session
    def determinate_back_link
      session[:company_payment_history] = true if request.referer&.include?(payment_history_path)

      payment_details_back_link = request.referer || payment_history_path
      Security::RefererXssHandler.call(referer: payment_details_back_link)
      session[:payment_details_back_link] = payment_details_back_link
    end

    # Store file details in the session
    def store_file_details_in_session(service)
      session[:payment_history_file_name] = service.file_url
      session[:payment_history_file_url] = payment_history_export_download_path(exportId: export_id)
    end
  end
end
