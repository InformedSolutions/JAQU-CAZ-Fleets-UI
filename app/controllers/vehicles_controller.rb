# frozen_string_literal: true

##
# Controller used to manage adding vehicles to the fleet manually.
# It should use similar approach as VCCS UI
#
class VehiclesController < ApplicationController
  # 404 HTTP status from API mean vehicle in not found in DLVA database. Redirects to the proper page.
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found
  # checks if VRN is present in the session
  before_action :check_vrn, only: %i[details confirm_details exempt incorrect_details not_found]

  ##
  # Renders the first step of checking the vehicle compliance.
  # If it was called using GET method, it clears @errors variable.
  #
  # ==== Path
  #    GET /vehicles/enter_details
  #
  def enter_details
    session[:vrn] = nil
  end

  ##
  # Validates +vrn+ submitted by the user.
  # If it is valid, redirects to {confirm details}[rdoc-ref:VehiclesController.details]
  # If not, renders {enter details}[rdoc-ref:VehiclesController.enter_details] with errors
  #
  # ==== Path
  #    POST /vehicles/enter_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, string, required in the query
  #
  def submit_details
    form = VrnForm.new(params[:vrn])
    unless form.valid?
      @errors = form.errors.messages
      return render enter_details_vehicles_path
    end

    session[:vrn] = form.vrn
    redirect_to details_vehicles_path
  end

  ##
  # Renders vehicle details form.
  #
  # ==== Path
  #
  #    GET /vehicles/details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def details
    @vehicle_details = VehicleDetails.new(vrn)
    redirect_to exempt_vehicles_path if @vehicle_details.exempt?
  end

  ##
  # Verifies if user confirms the vehicle's details.
  # If yes, renders to {incorrect details}[rdoc-ref:VehiclesController.local_authority]
  # If no, redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  # ==== Path
  #    POST /vehicles/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-vehicle+ - user confirmation of vehicle details, 'yes' or 'no', required in the query
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-vehicle+ - lack of it redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  def confirm_details
    form = ConfirmationForm.new(confirmation)
    return redirect_to details_vehicles_path, alert: confirmation_error(form) unless form.valid?

    return redirect_to incorrect_details_vehicles_path unless form.confirmed?

    add_vehicle_to_fleet
  end

  ##
  # Renders the page for exempt vehicles.
  #
  # ==== Path
  #
  #    GET /vehicles/exempt
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def exempt
    @vehicle_registration = vrn
  end

  ##
  # Renders the page for incorrect details.
  #
  # ==== Path
  #
  #    GET /vehicles/incorrect_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def incorrect_details
    @vehicle_registration = vrn
  end

  ##
  # Renders the page for vehicles not found in the DVLA databsse.
  #
  # ==== Path
  #
  #    GET /vehicles/incorrect_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def not_found
    @vehicle_registration = vrn
  end

  private

  # Check if vrn is present in the session
  def check_vrn
    return if vrn

    Rails.logger.warn 'VRN is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicles_path
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-vehicle']
  end

  # Add vehicle with given VRN to the user's fleet
  def add_vehicle_to_fleet
    current_user.add_vehicle(vrn: vrn)
    session[:vrn] = nil
    redirect_to fleets_path
  end

  # Redirects to {vehicle not found}[rdoc-ref:VehiclesController.unrecognised_vehicle]
  def vehicle_not_found
    redirect_to not_found_vehicles_path
  end
end
