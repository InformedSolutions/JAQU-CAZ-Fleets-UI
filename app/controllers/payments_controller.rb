# frozen_string_literal: true

##
# Controller used to pay for fleet
#
class PaymentsController < ApplicationController
  before_action :check_la, only: %i[matrix submit review]

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
    return redirect_to first_upload_fleets_path if current_user.fleet.empty?

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
    @charges = charges
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
  # Renders review payment page.
  #
  # ==== Path
  #
  #    :GET /payments/review
  #
  def review
    @zone = CleanAirZone.find(@zone_id)
    @days_to_pay = days_to_pay(helpers.new_payment_data[:details])
    @total_to_pay = total_to_pay(helpers.new_payment_data[:details])
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
    @details = vrn_to_pay(helpers.new_payment_data[:details])
  end

  ##
  # Makes a request to initiate payment on backend Payment-API.
  #
  # ==== Path
  #
  #    :POST /payments/initiate_payment
  #
  def initiate_payment
    response = MakePayment.call(payment_data: helpers.new_payment_data,
                                user_id: current_user.user_id,
                                return_url: result_payments_url)
    store_payment_data_in_session(response)
    redirect_to response['nextUrl']
  end

  ##
  # The page used as a landing point after the GOV.UK payment process.
  #
  # Calls +/payments/:id+ backed endpoint to get payment status
  #
  # Redirects to either success or failure payments path
  #
  # ==== Path
  #     GET /payments/result
  #
  # ==== Params
  # * +payment_id+ - id of the created payment, required in the session
  # * +la_id+ - id of the selected CAZ, required in the session
  def result
    payment_data = helpers.initiated_payment_data
    payment = PaymentStatus.new(payment_data[:payment_id], payment_data[:la_id])
    save_payment_details(payment)
    payment.success? ? redirect_to(success_payments_path) : redirect_to(failure_payments_path)
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
    payment_data = helpers.initiated_payment_data
    @payment_details = PaymentDetails.new(session_details: payment_data,
                                          entries_paid: days_to_pay(payment_data[:details]),
                                          total_charge: total_to_pay(payment_data[:details]))
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
                                          entries_paid: days_to_pay(data[:details]),
                                          total_charge: total_to_pay(data[:details]))
  end

  private

  # Moves stored data to another key in session and stores new payment id
  def store_payment_data_in_session(response)
    store_params = { payment_id: response['paymentId'] }
    SessionManipulation::SetPaymentId.call(session: session, params: store_params)
    SessionManipulation::AddCurrentPayment.call(session: session)
  end

  # Saves payment details using SessionManipulation::SetPaymentDetails
  def save_payment_details(payment)
    SessionManipulation::SetPaymentDetails.call(session: session,
                                                email: payment.user_email,
                                                payment_reference: payment.payment_reference,
                                                external_id: payment.external_id)
  end

  # Checks if the user selected LA
  def check_la
    @zone_id = helpers.new_payment_data[:la_id]
    redirect_to payments_path unless @zone_id
  end

  # loads selected vrns to pay
  def vrn_to_pay(details)
    @vrn_to_pay ||= details.reject { |_k, vrn| vrn.symbolize_keys![:dates].empty? }
  end

  # calculate total amount to pay
  def total_to_pay(details)
    vrn_to_pay(details).sum { |_k, vrn| vrn[:dates].length * vrn[:charge] }
  end

  # collects all dates to pay
  def days_to_pay(details)
    vrn_to_pay(details).collect { |_k, vrn| vrn[:dates] }.flatten.count
  end

  # Fetches charges with params saved in the session
  def charges
    query_data = helpers.payment_query_data
    data = current_user.charges(zone_id: @zone_id, vrn: query_data[:vrn],
                                direction: query_data[:direction])
    SessionManipulation::AddVehicleDetails.call(session: session, params: data.vehicle_list)
    data
  end

  # Permits all the form params
  def payment_params
    params.permit(:authenticity_token, :commit,
                  payment: [:vrn_search, :next_vrn, :previous_vrn, :vrn_list, vehicles: {}])
  end

  # Permits local-authority
  def la_params
    params.permit('local-authority', :authenticity_token, :commit)
  end
end
