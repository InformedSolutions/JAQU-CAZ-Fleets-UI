# frozen_string_literal: true

##
# Controller used to pay for fleet
#
# rubocop:disable Metrics/ClassLength
class PaymentsController < ApplicationController
  before_action :check_la, only: %i[matrix submit review select_payment_method
                                    submit_payment_method]
  before_action :assign_back_button_url, only: %i[index select_payment_method]
  before_action :assign_debit, only: %i[select_payment_method]

  ##
  # Renders payment page.
  # If the fleet is empty, redirects to {rdoc-ref:FleetsController.first_upload}
  # [rdoc-ref:FleetsController.first_upload]
  #
  # ==== Path
  #
  #    :GET /payments
  #
  def index
    return redirect_to first_upload_fleets_path if current_user.fleet.total_vehicles_count < 2

    @zones = CleanAirZone.all
  end

  ##
  # Validates and saves selected local authority.
  #
  # ==== Path
  #
  #    :POST /payments
  #
  def local_authority
    form = LocalAuthorityForm.new(authority: la_params['local-authority'])
    if form.valid?
      SessionManipulation::AddLaId.call(session: session, params: la_params)
      redirect_to matrix_payments_path
    else
      redirect_to payments_path, alert: confirmation_error(form, :authority)
    end
  end

  ##
  # Renders payment matrix page.
  #
  # ==== Path
  #
  #    :GET /payments/matrix
  #
  def matrix
    @zone = CleanAirZone.find(@zone_id)
    @dates = PaymentDates.call
    @search = helpers.payment_query_data[:search]
    @errors = validate_search_params unless @search.nil?
    @charges = @errors || @search.nil? ? charges : charges_by_vrn
  end

  ##
  # Saves payment and query details.
  # If commit value equals 'Continue' redirects to :review,
  # else redirects to matrix with new query data.
  #
  # ==== Path
  #
  #    :POST /payments/submit
  #
  def submit
    SessionManipulation::AddPaymentDetails.call(session: session, params: payment_params)
    return redirect_to review_payments_path if params[:commit] == 'Continue'

    SessionManipulation::AddQueryDetails.call(session: session, params: payment_params)
    redirect_to matrix_payments_path
  end

  ##
  # Clears search form on payment matrix.
  #
  # ==== Path
  #
  #    :GET /payments/clear_search
  #
  def clear_search
    SessionManipulation::ClearVrnSearch.call(session: session)

    redirect_to matrix_payments_path
  end

  ##
  # Renders review payment page.
  #
  # ==== Path
  #
  #    :GET /payments/review
  #
  def review
    @zone = CleanAirZone.find(@zone_id)
    @days_to_pay = helpers.days_to_pay(helpers.new_payment_data[:details])
    @total_to_pay = total_to_pay_from_session
  end

  ##
  # Renders review details
  #
  # ==== Path
  #
  #    :GET /payments/review_details
  #
  def review_details
    @zone = CleanAirZone.find(@zone_id)
    @details = helpers.vrn_to_pay(helpers.new_payment_data[:details])
  end

  ##
  # Renders the select payment method page
  # If no active mandates are present redirects to the initiate card payment page
  #
  # ==== Path
  #
  #    :GET /payments/select_payment_method
  #
  def select_payment_method
    redirect_to initiate_payments_path if @debit.active_mandates.empty?
  end

  ##
  # Validate submit payment method and depending on the type, redirects to:
  #  {rdoc-ref:DirectDebitsController.confirm_direct_debit} if +direct_debit_method+ value is true
  #  or call {rdoc-ref:PaymentsController.initiate_card_payment} method if +direct_debit_method+ value is false
  #  or render errors if +direct_debit_method+ value is null
  #
  # ==== Path
  #
  #    :POST /payments/confirm_payment_method
  #
  # ==== Params
  # * +la_id+ - id of the selected CAZ, required in the session
  def confirm_payment_method
    session[:payment_method] = params['payment_method']
    if params['payment_method'] == 'true'
      redirect_to confirm_debits_path
    elsif params['payment_method'] == 'false'
      redirect_to initiate_payments_path
    else
      @errors = 'Choose Direct Debit or Card payment'
      render :select_payment_method
    end
  end

  ##
  # Renders page after successful payment
  #
  # ==== Path
  #   GET /payments/success
  #
  # ==== Params
  # * +payment_reference+ - payment reference, required in the session
  # * +external_id+ - external payment id, required in the session
  # * +user_email+ - email of the user which performed the payment, required in the session
  # * +la_id+ - selected local authority ID
  def success
    payments = helpers.initiated_payment_data
    @payment_details = PaymentDetails.new(session_details: payments,
                                          entries_paid: helpers.days_to_pay(payments[:details]),
                                          total_charge: helpers.total_to_pay(payments[:details]))
  end

  ##
  # Render page after unsuccessful payment
  #
  # ==== Path
  #   GET /payments/failure
  #
  # ==== Params
  # * +payment_reference+ - payment reference, required in the session
  # * +external_id+ - external payment id, required in the session
  def failure
    data = helpers.initiated_payment_data
    @payment_details = PaymentDetails.new(session_details: data,
                                          entries_paid: helpers.days_to_pay(data[:details]),
                                          total_charge: helpers.total_to_pay(data[:details]))
  end

  ##
  # Render page with payment details.
  #
  # ==== Path
  #   GET /payments/post_payment_details
  #
  def post_payment_details
    @zone = CleanAirZone.find(@zone_id)
    @details = helpers.vrn_to_pay(helpers.initiated_payment_data[:details])
  end

  private

  # Check if provided VRN in search is valid
  def validate_search_params
    form = SearchVrnForm.new(@search)
    return if form.valid?

    SessionManipulation::ClearVrnSearch.call(session: session)
    form.errors.messages[:vrn]
  end

  # Fetches charges with params saved in the session
  def charges
    query_data = helpers.payment_query_data
    data = current_user.charges(zone_id: @zone_id, vrn: query_data[:vrn],
                                direction: query_data[:direction])
    SessionManipulation::AddVehicleDetails.call(session: session, params: data.vehicle_list)
    data
  end

  # Fetches charges with vrn saved in session
  def charges_by_vrn
    data = current_user.charges_by_vrn(
      zone_id: @zone_id,
      vrn: helpers.payment_query_data[:search]
    )
    SessionManipulation::AddVehicleDetails.call(session: session, params: data.vehicle_list)
    data
  end

  # Permits all the form params
  def payment_params
    params.permit(:authenticity_token, :commit, :allSelectedCheckboxesCount,
                  payment: [:vrn_search, :next_vrn, :previous_vrn, :vrn_list, vehicles: {}])
  end

  # Permits local-authority
  def la_params
    params.permit('local-authority', :authenticity_token, :commit)
  end
end
# rubocop:enable Metrics/ClassLength
