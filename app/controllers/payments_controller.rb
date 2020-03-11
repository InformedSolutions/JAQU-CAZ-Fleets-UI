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
      SessionManipulation::AddLaId.call(
        session: session, params: la_params
      )
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
    @days_to_pay = days_to_pay
    @total_to_pay = total_to_pay
  end

  ##
  # Renders reveiw details
  #
  # ==== Path
  #
  #    :GET /payments/review_details
  #
  def review_details
    @zone = CleanAirZone.find(@zone_id)
    @details = vrn_to_pay
  end

  ##
  # Makes a request to initiate payment on backend Payment-API.
  #
  # ==== Path
  #
  #    :POST /payments/initiate_payment
  #
  def initiate_payment
    next_url = MakePayment.call(
      payment_data: helpers.new_payment_data,
      user_id: current_user.user_id
    )

    SessionManipulation::AddCurrentPayment.call(session: session)

    redirect_to next_url
  end

  private

  # Checks if the user selected LA
  def check_la
    @zone_id = helpers.new_payment_data[:la_id]
    redirect_to payments_path unless @zone_id
  end

  # loads selected vrns to pay
  def vrn_to_pay
    @vrn_to_pay ||= helpers.new_payment_data[:details].reject do |_k, vrn|
      vrn.symbolize_keys![:dates].empty?
    end
  end

  # calculate total amount to pay
  def total_to_pay
    vrn_to_pay.sum do |_k, vrn|
      vrn[:dates].length * vrn[:charge]
    end
  end

  # collects all dates to pay
  def days_to_pay
    vrn_to_pay.collect { |_k, vrn| vrn[:dates] }.flatten.count
  end

  # Fetches charges with params saved in the session
  def charges
    data = current_user.charges(
      zone_id: @zone_id,
      vrn: helpers.payment_query_data[:vrn],
      direction: helpers.payment_query_data[:direction]
    )
    SessionManipulation::AddVehicleDetails.call(session: session, params: data.vehicle_list)
    data
  end

  # Permits all the form params
  def payment_params
    params.permit(
      :authenticity_token,
      :commit,
      payment: [:vrn_search, :next_vrn, :previous_vrn, :vrn_list, vehicles: {}]
    )
  end

  # Permits local-authority
  def la_params
    params.permit('local-authority', :authenticity_token, :commit)
  end
end
