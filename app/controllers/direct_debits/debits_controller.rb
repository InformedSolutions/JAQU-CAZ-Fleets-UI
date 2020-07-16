# frozen_string_literal: true

##
# Module used for Direct Debits flow
module DirectDebits
  ##
  # Controller used to manage and pay Direct Debits
  #
  class DebitsController < ApplicationController
    include CheckPermissions
    before_action -> { check_permissions(allow_manage_mandates?) }, only: %i[index new create]
    before_action -> { check_permissions(allow_make_payments?) }, except: %i[index new create]
    before_action :check_la, only: %i[confirm first_mandate]
    before_action :assign_debit, only: %i[confirm index new first_mandate]
    before_action :check_active_caz_mandates, only: %i[first_mandate]
    before_action :assign_back_button_url, only: %i[confirm index new first_mandate]
    before_action :clear_payment_method, only: %i[first_mandate initiate]

    ##
    # Renders the confirm Direct Debit page
    # Check if any active mandates present for chosen local authority
    # Redirect to {rdoc-ref.first_mandate} if no active mandates
    #
    # ==== Path
    #
    #    :GET /payments/debits/confirm
    #
    def confirm
      caz_mandates = @debit.caz_mandates(@zone_id)
      if caz_mandates.present?
        @zone_name = CleanAirZone.find(@zone_id)&.name
        @mandate_id = caz_mandates['id']
        @created_at = caz_mandates['created']
        @total_to_pay = total_to_pay_from_session
      else
        redirect_to first_mandate_debits_path
      end
    end

    ##
    # Makes a request to initiate Direct Debit payment
    #
    # ==== Path
    #
    #    :POST /payments/debits/initiate
    #
    def initiate
      service_response = create_direct_debit_payment
      details = DirectDebits::Details.new(service_response)
      payment_details_to_session(details)
      redirect_to success_debits_path
    end

    ##
    # Renders page after successful Direct Debit payment
    #
    # ==== Path
    #
    #    :GET /payments/debits/success
    #
    def success
      payments = helpers.initiated_payment_data
      @payment_details = Payments::Details.new(session_details: payments,
                                               entries_paid: helpers.days_to_pay(payments[:details]),
                                               total_charge: helpers.total_to_pay(payments[:details]))
    end

    ##
    # Renders the first create a Direct Debit mandate
    #
    # ==== Path
    #
    #    :GET /payments/debits/first_mandate
    #
    def first_mandate
      # renders static page
    end

    ##
    # Renders active Direct Debit mandates
    # Redirect to #new if there is no mandate assigned to the account.
    #
    # ==== Path
    #
    #    GET /payments/debits
    #
    def index
      redirect_to new_debit_path if @debit.active_mandates.empty?

      @mandates = @debit.active_mandates
      @zones_without_mandate = @debit.inactive_mandates
    end

    ##
    # Renders a selector to add a new mandate.
    # If there is no possible new mandates, redirects to #index
    #
    # ==== Path
    #
    #    GET /payments/debits/new
    #
    def new
      @zones = @debit.inactive_mandates

      redirect_to debits_path if @zones.empty?
    end

    ##
    # Validates and creates a new mandate.
    #
    # ==== Path
    #
    #    POST /payments/debits
    #
    def create
      form = LocalAuthorityForm.new(authority: params['local-authority'])
      if form.valid?
        create_debit_mandate(form.authority)
      else
        redirect_to new_debit_path, alert: confirmation_error(form, :authority)
      end
    end

    ##
    # Renders the cancel payment page
    #
    # ==== Path
    #
    #    GET /payments/cancel
    #
    def cancel
      # renders static page
    end

    private

    # creates Direct Debit payment for selected mandate.
    def create_direct_debit_payment
<<<<<<< HEAD
      Payments::MakeDebitPayment.call(payment_data: helpers.new_payment_data,
                                      account_id: current_user.account_id,
                                      user_id: current_user.user_id,
                                      user_email: current_user.email,
                                      mandate_id: params['mandate_id'])
=======
      MakeDebitPayment.call(payment_data: helpers.new_payment_data,
                            account_id: current_user.account_id,
                            user_id: current_user.user_id,
                            user_email: current_user.email,
                            mandate_id: params['mandate_id'])
>>>>>>> release-candidate/v1.2.0
    end

    # Saves initiated Direct Debit payment details to the session
    def payment_details_to_session(details)
      SessionManipulation::AddCurrentPayment.call(session: session)
      SessionManipulation::SetPaymentDetails.call(session: session,
                                                  email: current_user.email,
                                                  payment_reference: details.payment_reference,
                                                  external_id: details.external_id)
    end

    # Creates a Direct Debit mandate and redirects to response url
    def create_debit_mandate(caz_id)
      service_response = DebitsApi.create_mandate(
        account_id: current_user.account_id,
        caz_id: caz_id,
        return_url: debits_url
      )
      redirect_to service_response['nextUrl']
    end

    # Redirect to {rdoc-ref:index} if active mandates are present
    def check_active_caz_mandates
      redirect_to debits_path if @debit.caz_mandates(@zone_id).present?
    end

    # clear +payment_method+ from the session
    def clear_payment_method
      session[:payment_method] = nil
    end
  end
end
