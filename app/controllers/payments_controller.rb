# frozen_string_literal: true

##
# Controller used to pay for fleet
#
class PaymentsController < ApplicationController
  before_action :assign_fleet
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
    return redirect_to first_upload_fleets_path if @fleet.empty?

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
    form = LocalAuthorityForm.new(authority: params['local-authority'])
    if form.valid?
      session[:new_payment] = { la_id: form.authority }
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
    @search = search
    @charges = current_user.charges(zone_id: @zone_id, vrn: query_vrn, direction: direction)
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
    save_payment_details
    return redirect_to review_payments_path if params[:commit] == 'Continue'

    save_query_details
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
  end

  private

  # Creates instant variable with fleet object
  def assign_fleet
    @fleet = current_user.fleet
  end

  # Checks if the user selected LA
  def check_la
    @zone_id = helpers.new_payment_data[:la_id]
    redirect_to payments_path unless @zone_id
  end

  # Saves payment details in the session
  def save_payment_details
    session[:new_payment][:details] = params.dig(:payment, :vehicles)
  end

  # Creates :payment_query hash in the session and assigns attributes based on :commit
  def save_query_details
    session[:payment_query] = {}
    search = params.dig(:payment, :vrn_search)
    session[:payment_query][:search] = search if search
    save_direction_and_vrn('next') if params[:commit] == 'Next'
    save_direction_and_vrn('previous') if params[:commit] == 'Previous'
  end

  # Saves direction and vrn in the session
  def save_direction_and_vrn(direction)
    session[:payment_query][:direction] = direction
    session[:payment_query][:vrn] = params.dig(:payment, "#{direction}_vrn")
  end

  # Digs for search value in the session
  def search
    payment_query[:search]
  end

  # Digs for direction value in the session
  def direction
    payment_query[:direction]
  end

  # Digs for vrn value in the session
  def query_vrn
    payment_query[:vrn]
  end

  # Extracts :payment_query form the session
  def payment_query
    (session[:payment_query] || {}).symbolize_keys
  end
end
