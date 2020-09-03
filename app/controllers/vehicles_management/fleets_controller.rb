# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Controller used to manage fleet
  #
  class FleetsController < ApplicationController
    include CheckPermissions
    include ChargeabilityCalculator

    before_action -> { check_permissions(allow_manage_vehicles?) }
    before_action :assign_fleet
    before_action :check_vrn, only: %i[delete confirm_delete]
    before_action :check_job_status, only: %i[index]
    before_action :clear_user_data, only: %i[index]

    ##
    # Renders submission method selection page
    #
    # ==== Path
    #
    #    :GET /fleets/submission_method
    #
    def submission_method
      # renders static page
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
      form = VehiclesManagement::SubmissionMethodForm.new(submission_method: params['submission-method'])
      session[:submission_method] = form.submission_method
      if form.valid?
        redirect_to form.manual? ? enter_details_vehicles_path : uploads_path
      else
        @errors = form.errors
        render :submission_method
      end
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
    rescue BaseApi::Error400Exception
      return redirect_to fleets_path unless page == 1
    end

    ##
    # Verifies if user confirms to add another vehicle
    # If yes, redirects to {upload vehicle}[rdoc-ref:upload]
    # If no, redirects to {dashboard page}[rdoc-ref:DashboardController.index]
    # If form was not confirmed, redirects to {manage vehicles page}[rdoc-ref:index]
    #
    # ==== Path
    #
    #    POST /fleets
    #
    def create
      form = VehiclesManagement::ConfirmationForm.new(params['confirm-vehicle-creation'])
      session[:confirm_vehicle_creation] = form.confirmation
      determinate_next_step(form)
    end

    ##
    # Renders the view for first CSV upload
    #
    # ==== Path
    #
    #    :GET /fleets/first_upload
    #
    def first_upload
      # renders static page
    end

    ##
    # Assigns VRN to remove. Redirects to {delete view}[rdoc-ref:delete]
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
      form = VehiclesManagement::ConfirmationForm.new(confirm_delete_param)
      return redirect_to delete_fleets_path, alert: confirmation_error(form) unless form.valid?

      remove_vehicle if form.confirmed?
      session[:vrn] = nil
      redirect_to after_removal_redirect_path(@fleet)
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

    # Verifies if user confirms to add another vehicle
    # If yes, redirects to {upload vehicle}[rdoc-ref:upload]
    # If no, redirects to {dashboard page}[rdoc-ref:DashboardController.index]
    # If form was not confirmed, redirects to {manage vehicles page}[rdoc-ref:index]
    def determinate_next_step(form)
      if form.valid?
        redirect_to form.confirmed? ? enter_details_vehicles_path : dashboard_path
      else
        redirect_to fleets_path, alert: form.errors.messages[:confirmation].first
      end
    end

    # Removes vehicle and sets successful flash message
    def remove_vehicle
      @fleet.delete_vehicle(vrn)
      flash[:success] = I18n.t(
        'vrn_form.messages.single_vrn_removed',
        vrn: session[:vrn]
      )
    end

    # Returns redirect path after successful removal of vehicle from the fleet
    def after_removal_redirect_path(fleet)
      fleet.empty? ? dashboard_path : fleets_path
    end

    # Clears upload job data
    # Clears show_continue_button from session when user lands on fleets page after end of CSV import
    def clear_user_data
      clear_upload_job_data
      session[:show_continue_button] = nil if session[:show_continue_button] == true
    end
  end
end
