# frozen_string_literal: true

##
# Controller used to manage and pay direct debits
#
class DebitsController < ApplicationController
  before_action :check_la, only: %i[first_mandate]
  before_action :assign_debit, only: %i[confirm index new]
  before_action :assign_back_button_url, only: %i[confirm index new first_mandate]
  # TODO: Remove after proper API integration
  # saves reference to the request for mocks
  before_action :save_request_for_mocks

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
    redirect_to first_mandate_debits_path if caz_mandates.empty?

    @total_to_pay = total_to_pay_from_session
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
                                             user_id: current_user.user_id)

    details = DirectDebitDetails.new(service_response)
    payment_details_to_session(details)
    redirect_to success_payments_path
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
                                                email: details.user_email,
                                                payment_reference: details.payment_reference,
                                                external_id: details.external_id)
  end

  # Creates a direct debit mandate and redirects to response url
  def create_debit_mandate(zone_id)
    service_response = DebitsApi.add_mandate(
      account_id: current_user.account_id,
      zone_id: zone_id,
      return_url: debits_path
    )
    redirect_to service_response['nextUrl']
  end

  # It assigns current request to the global variable
  # It is used for the mocks to have access to the session
  # TODO: Remove after proper API integration
  def save_request_for_mocks
    $request = request
  end
end
