# frozen_string_literal: true

##
# Controller used to manage adding vehicles to the fleet manually.
# It should use similar approach as VCCS UI
#
class VehiclesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn, only: %i[confirm_details]

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
  # If it is valid, redirects to {confirm details}[rdoc-ref:VehiclesController.confirm_details]
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
    redirect_to confirm_details_vehicles_path
  end

  ##
  # Renders vehicle details form.
  #
  # ==== Path
  #
  #    GET /vehicle_checkers/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  def confirm_details
    # Nothing for now
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
end
