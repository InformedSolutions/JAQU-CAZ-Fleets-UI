# frozen_string_literal: true

##
# Controller used to manage fleet
#
class FleetsController < ApplicationController
  before_action :assign_fleet
  before_action :check_vrn, only: %i[delete confirm_delete]

  ##
  # Renders submission method selection page
  #
  # ==== Path
  #
  #    :GET /fleets/submission_method
  #
  def submission_method
    session[:add_vehicle_back_button] = submission_method_fleets_path
  end

  ##
  # Validates the submission method form and redirects to selected method screen.
  #
  # ==== Path
  #
  #    :POST /fleets/submission_method
  #
  # ==== Params
  # * +submission-method+ - manual or upload - selected submission method
  #
  def submit_method
    form = SubmissionMethodForm.new(submission_method: params['submission-method'])
    unless form.valid?
      @errors = form.errors
      render :submission_method and return
    end

    redirect_to form.manual? ? enter_details_vehicles_path : uploads_path
  end

  ##
  # Renders manage fleet page.
  # If the fleet is empty, redirects to :submission_method
  #
  # ==== Path
  #
  #    :GET /fleets
  #
  # ==== Params
  #
  # * +page+ - used to paginate vehicles list, defaults to 1, present in the query params
  #
  def index
    return redirect_to submission_method_fleets_path if @fleet.empty?

    page = (params[:page] || 1).to_i
    @pagination = @fleet.pagination(page: page)
    @zones = CleanAirZone.all
  end

  ##
  # Verifies if user confirms to add another vehicle
  # If yes, redirects to {upload vehicle}[rdoc-ref:FleetsController.upload]
  # If no, redirects to {dashboard page}[rdoc-ref:DashboardController.index]
  # If form was not confirmed, redirects to {manage vehicles page}[rdoc-ref:FleetsController.index]
  #
  # ==== Path
  #
  #    POST /fleets
  #
  def create
    form = ConfirmationForm.new(params['confirm-vehicle-creation'])
    unless form.valid?
      return redirect_to fleets_path, alert: form.errors.messages[:confirmation].first
    end

    redirect_to form.confirmed? ? enter_details_vehicles_path : dashboard_path
  end

  ##
  # Renders the view for first CSV upload
  #
  # ==== Path
  #
  #    :GET /fleets/first_upload
  #
  def first_upload
    # nothing for now
  end

  ##
  # Assigns VRN to remove. Redirects to {delete view}[rdoc-ref:FleetsController.delete]
  #
  # ==== Path
  #
  #    :GET /fleets/assign_delete
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in params
  #
  def assign_delete
    return redirect_to fleets_path unless params[:vrn]

    session[:vrn] = params[:vrn]
    redirect_to delete_fleets_path
  end

  ##
  # Renders the confirmation page for deleting vehicles from the fleet.
  #
  # ==== Path
  #
  #    GET /fleets/delete
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def delete
    @vehicle_registration = vrn
  end

  ##
  # Removes the vehicle from the fleet if the user confirms this.
  #
  # ==== Path
  #
  #    POST /fleets/delete
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-delete+ - form confirmation, possible values: 'yes', 'no', nil
  #
  def confirm_delete
    form = ConfirmationForm.new(confirm_delete_param)
    return redirect_to delete_fleets_path, alert: confirmation_error(form) unless form.valid?

    @fleet.delete_vehicle(vrn) if form.confirmed?
    session[:vrn] = nil
    redirect_to @fleet.empty? ? dashboard_path : fleets_path
  end

  private

  # Creates instant variable with fleet object
  def assign_fleet
    @fleet = current_user.fleet
  end

  # Check if vrn is present in the session
  def check_vrn
    return if vrn

    Rails.logger.warn 'VRN is missing in the session. Redirecting to fleets_path'
    redirect_to fleets_path
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end

  # Extract 'confirm-delete' from params
  def confirm_delete_param
    params['confirm-delete']
  end
end
