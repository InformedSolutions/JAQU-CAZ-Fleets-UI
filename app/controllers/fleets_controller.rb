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
    # Renders static view
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

    redirect_to action: form.manual? ? :enter_details : :upload
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
  # Renders the view for VRN submission
  #
  # ==== Path
  #
  #    :GET /fleets/enter_details
  #
  def enter_details
    # nothing foe now
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
end
