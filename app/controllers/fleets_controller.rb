# frozen_string_literal: true

##
# Controller used to manage fleet
#
class FleetsController < ApplicationController
  before_action :assign_fleet

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

    redirect_to action: form.manual? ? :add_vehicle : :upload
  end

  ##
  # Renders manage fleet page.
  # If the fleet is empty, redirects to :submission_method
  #
  # ==== Path
  #
  #    :GET /fleets
  #
  def index
    redirect_to submission_method_fleets_path if @fleet.vehicles.size.zero?
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
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      return redirect_to fleets_path, alert: form.errors.messages[:confirmation].first
    end

    determinate_next_page(form)
  end

  ##
  # Renders the view for CSV upload
  #
  # ==== Path
  #
  #    :GET /fleets/upload
  #
  def upload
    # nothing for now
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
  # Renders the view for adding vehicle
  #
  # ==== Path
  #
  #    :GET /fleets/add_vehicle
  #
  def add_vehicle
    # Renders static view
  end

  # For demonstration purposes
  def demonstrate_adding_vehicle
    @fleet.add_vehicle(vrn: "CAZ#{rand(100...300)}")
    redirect_to fleets_path
  end

  private

  # Creates instant variable with fleet object
  def assign_fleet
    @fleet = current_user.fleet
  end

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-vehicle-creation']
  end

  # Redirects to add vehicle page if form confirmed.
  # If not, redirects to dashboard page
  def determinate_next_page(form)
    if form.confirmed?
      redirect_to add_vehicle_fleets_path
    else
      redirect_to dashboard_path
    end
  end
end
