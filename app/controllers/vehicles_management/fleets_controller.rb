# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Controller used to manage fleet
  #
  class FleetsController < ApplicationController # rubocop:disable Metrics/ClassLength
    include CheckPermissions
    include ChargeabilityCalculator
    include PaymentFeatures

    before_action -> { check_permissions(allow_manage_vehicles?) }
    before_action :assign_fleet
    before_action :check_vrn, only: %i[remove confirm_remove]
    before_action :set_cache_headers, only: :index
    before_action :check_job_status, only: :index
    before_action :clear_user_data, only: :index

    ##
    # Renders manage fleet page. If the fleet is empty, redirects to :choose_method
    #
    # ==== Path
    #
    #    :GET /fleets
    #
    # ==== Params
    #
    # * +page+ - used to paginate vehicles list, defaults to 1, present in the query params
    # * +only_chargeable+ - flag, to filter out non-charged vehicles
    # * +page_size+ - integer value, to manipulate number of vehicles on the page
    # * +vrn+ - alphanumeric character part of vrn number
    #
    def index
      return redirect_to choose_method_fleets_path if @fleet.empty?

      assign_index_variables
    rescue BaseApi::Error400Exception
      return redirect_to fleets_path unless params[:page] == 1
    end

    ##
    # Action adds another zone on the Vehicle Management page if there are more than 3 CAZ
    # available. Redirect back to previous page.
    #
    # ==== Path
    #
    #    :GET /fleets/add_another_zone
    #
    def add_another_zone
      VehiclesManagement::DynamicCazes::AddAnotherCaz.call(session: session)
      reload_dynamic_table
    end

    ##
    # Action removes slelected zone on the Vehicle Management page if there are
    # more than 3 CAZ available. Redirect back to previous page.
    #
    # ==== Path
    #
    #    :GET /fleets/remove_selected_zone
    #
    # ==== Params
    #
    # * +key+ - uuid key of CAZ select box
    #
    def remove_selected_zone
      if params[:key].present?
        VehiclesManagement::DynamicCazes::RemoveSelectedCaz.call(
          session: session, user: current_user, key: params[:key]
        )
      end
      reload_dynamic_table
    end

    ##
    # Action changes selected zone on the Vehicle Management page if there are
    # more than 3 CAZ available. Redirect back to previous page.
    #
    # ==== Path
    #
    #    :GET /fleets/select_zone
    #
    # ==== Params
    #
    # * +key+ - uuid key CAZ select box
    # * +zone_id+ - uuid of selected CAZ
    #
    def select_zone
      if params[:key].present? && params[:zone_id].present?
        VehiclesManagement::DynamicCazes::SelectCaz.call(
          session: session, user: current_user, key: params[:key],
          zone_id: params[:zone_id]
        )
      end

      reload_dynamic_table
    end

    ##
    # Validates a search form and redirects to the proper page
    #
    # ==== Path
    #
    #    :POST /manage_vehicles/submit_search
    #
    def submit_search
      form = SearchVrnForm.new(params[:vrn])
      per_page = (params[:per_page] || 10).to_i
      if form.valid? && @fleet.pagination(vrn: form.vrn, per_page: per_page).total_vehicles_count.zero?
        return redirect_to vrn_not_found_fleets_path(vrn: form.vrn, per_page: per_page)
      end

      redirect_to_proper_page(form)
    end

    ##
    # Renders no search results page when no vrn is found
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/vrn_not_found
    #
    def vrn_not_found
      @search = params[:vrn]
    end

    ##
    # Renders submission method selection page
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/choose_method
    #
    def choose_method
      # renders static page
    end

    ##
    # Validates the submission method form and redirects to selected method screen.
    #
    # ==== Path
    #
    #    :POST /manage_vehicles/choose_method
    #
    # ==== Params
    # * +submission-method+ - manual or upload - selected submission method
    #
    def submit_choose_method
      form = VehiclesManagement::SubmissionMethodForm.new(choose_method: params['submission-method'])
      session[:choose_method] = form.choose_method
      if form.valid?
        redirect_to form.manual? ? enter_details_vehicles_path : uploads_path
      else
        @errors = form.errors
        render :choose_method
      end
    end

    ##
    # Renders the view for first CSV upload
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/first_upload
    #
    def first_upload
      # renders static page
    end

    ##
    # Assigns VRN to remove. Redirects to {delete view}[rdoc-ref:delete]
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/assign_remove
    #
    # ==== Params
    # * +vrn+ - vehicle registration number, required in params
    #
    def assign_remove
      return redirect_to fleets_path unless params[:vrn]

      session[:vrn] = params[:vrn]
      redirect_to remove_fleets_path
    end

    ##
    # Renders the confirmation page for deleting vehicles from the fleet.
    #
    # ==== Path
    #
    #    GET /manage_vehicles/remove
    #
    # ==== Params
    # * +vrn+ - vehicle registration number, required in the session
    #
    def remove
      @vehicle_registration = vrn
    end

    ##
    # Removes the vehicle from the fleet if the user confirms this.
    #
    # ==== Path
    #
    #    POST /manage_vehicles/remove
    #
    # ==== Params
    # * +vrn+ - vehicle registration number, required in the session
    # * +confirm-delete+ - form confirmation, possible values: 'yes', 'no', nil
    #
    def confirm_remove
      form = VehiclesManagement::ConfirmationForm.new(confirm_delete_param)
      return redirect_to remove_fleets_path, alert: confirmation_error(form) unless form.valid?

      if form.confirmed?
        remove_vehicle
        session[:vrn] = nil
        redirect_to after_removal_redirect_path(@fleet)
      else
        redirect_to edit_fleets_path
      end
    end

    ##
    # Downloads a csv file from AWS S3
    #
    # ==== Path
    #
    #     GET /manage_vehicles/export
    #
    def export
      file_url = AccountsApi::Accounts.csv_exports(
        account_id: current_user.account_id,
        user_beta_tester: current_user.beta_tester
      )
      redirect_to file_url
    end

    ##
    # Renders edit tab
    #
    # ==== Path
    #
    #     GET /manage_vehicles/edit
    #
    def edit
      # renders static page with Manage Fleets tab
    end

    ##
    # Validates an edit fleet form and redirects to the proper page.
    #
    # ==== Path
    #
    #     POST /manage_vehicles/submit_edit
    #
    def submit_edit
      form = UsersManagement::EditFleetForm.new(params[:edit_option])
      if form.valid?
        redirect_to determine_edit_fleet_path(params[:edit_option])
      else
        flash.now.alert = form.first_error_message
        render :edit
      end
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

    # Removes vehicle and sets successful flash message
    def remove_vehicle
      @fleet.delete_vehicle(vrn)
      flash[:success] = I18n.t('vrn_form.messages.single_vrn_removed', vrn: session[:vrn])
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

    # Assign variables needed in :index view
    def assign_index_variables
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 10).to_i
      @search = params[:vrn]
      form = SearchVrnForm.new(@search)
      if form.valid?
        fetch_pagination_and_zones(page, per_page, @search)
      else
        fetch_pagination_and_zones(page, per_page)
      end
      assign_payment_enabled
    end

    # Load selected zones from session or AccountsApi
    def load_selected_zones
      @selected_zones = VehiclesManagement::DynamicCazes::SelectedCazes.call(
        session: session, user: current_user
      )
    end

    # reloads dynamic table on View Charges page using JS or redirect back to fleets page
    def reload_dynamic_table
      assign_index_variables
      respond_to do |format|
        format.js { render 'reload_dynamic_table' }
        format.html { redirect_back(fallback_location: fleets_path) }
      end
    end

    # Make api calls
    def fetch_pagination_and_zones(page = 1, per_page = 10, vrn = nil)
      @pagination = @fleet.pagination(
        page: page,
        per_page: per_page,
        only_chargeable: params[:only_chargeable],
        vrn: vrn
      )
      @zones = current_user.beta_tester ? CleanAirZone.all : CleanAirZone.visible_cazes
      load_selected_zones if @zones.count > 3
    end

    # Loads error from form if needed and redirect to fleets index with appropriate params
    def redirect_to_proper_page(form)
      flash.now[:alert] = form.first_error_message if form.first_error_message

      redirect_to fleets_path(vrn: form.vrn)
    end

    # Determine path to edit fleet option.
    def determine_edit_fleet_path(edit_option)
      case edit_option
      when 'add_single'
        enter_details_vehicles_path
      when 'add_multiple'
        uploads_path
      else
        root_path # change to remove vehicles page
      end
    end
  end
end
