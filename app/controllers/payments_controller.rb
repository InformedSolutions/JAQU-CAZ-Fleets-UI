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
  end

  private

  # Checks if the user selected LA
  def check_la
    @zone_id = helpers.new_payment_data[:la_id]
    redirect_to payments_path unless @zone_id
  end

  # Fetches charges with params saved in the session
  def charges
    current_user.charges(
      zone_id: @zone_id,
      vrn: helpers.payment_query_data[:vrn],
      direction: helpers.payment_query_data[:direction]
    )
  end

  # Permits all the form params
  def payment_params
    params.permit!
  end

  # Permits local-authority
  def la_params
    params.permit('local-authority')
  end
end
