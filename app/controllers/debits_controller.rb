# frozen_string_literal: true

##
# Controller used to manage and pay direct debits
#
class DebitsController < ApplicationController
  before_action :check_la, only: %i[confirm first_mandate]
  before_action :assign_debit, only: %i[confirm index new]
  before_action :assign_back_button_url, only: %i[confirm index new first_mandate]

  ##
  # Renders the confirm direct debit page
  # Check if any active mandates present for chosen local authority
  # Redirect to {rdoc-ref:MandatesController.first} if no active mandates
  #
  # ==== Path
  #
  #    :GET /payments/debits/confirm
  #
  def confirm
    caz_mandates = @debit.caz_mandates(@zone_id)
    if caz_mandates.present?
      @mandate_id = caz_mandates['id']
      @total_to_pay = total_to_pay_from_session
    else
      redirect_to first_mandate_debits_path
    end
  end

  ##
  # Makes a request to initiate direct debit payment
  #
  # ==== Path
  #
  #    :POST /payments/debits/initiate
  #
  def initiate
    service_response = MakeDebitPayment.call(payment_data: helpers.new_payment_data,
                                             account_id: current_user.account_id,
                                             user_id: current_user.user_id,
                                             mandate_id: params['mandate_id'])
    details = DirectDebitDetails.new(service_response)
    payment_details_to_session(details)
    redirect_to success_debits_path
  end

  def success
    payments = helpers.initiated_payment_data
    @payment_details = PaymentDetails.new(session_details: payments,
                                          entries_paid: helpers.days_to_pay(payments[:details]),
                                          total_charge: helpers.total_to_pay(payments[:details]))
  end

  ##
  # Renders the first create a direct debit mandate
  #
  # ==== Path
  #
  #    :GET /payments/debits/first_mandate
  #
  def first_mandate; end

  ##
  # Renders active direct debit mandates
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

  private

  # Creates an instance of DirectDebit class and assign it to +@debit+ variable
  def assign_debit
    @debit = DirectDebit.new(current_user.account_id)
  end

  # Saves initiated direct debit payment details to the session
  def payment_details_to_session(details)
    SessionManipulation::AddCurrentPayment.call(session: session)
    SessionManipulation::SetPaymentDetails.call(session: session,
                                                email: current_user.email,
                                                payment_reference: details.payment_reference,
                                                external_id: details.external_id)
  end

  # Creates a direct debit mandate and redirects to response url
  def create_debit_mandate(caz_id)
    service_response = DebitsApi.create_mandate(
      account_id: current_user.account_id,
      caz_id: caz_id,
      return_url: debits_url
    )
    redirect_to service_response['nextUrl']
  end
end
