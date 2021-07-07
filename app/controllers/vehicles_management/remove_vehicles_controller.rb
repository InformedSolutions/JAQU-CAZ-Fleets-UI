# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Controller used to remove vehicles from the fleet.
  #
  class RemoveVehiclesController < ApplicationController # rubocop:disable Metrics/ClassLength
    include CheckPermissions

    before_action -> { check_permissions(allow_manage_vehicles?) }
    before_action :set_cache_headers, only: :remove_vehicles

    ##
    # Renders the select vehicles to remove page.
    #
    # ==== Path
    #
    #    GET /manage_vehicles/remove_vehicles
    #
    def remove_vehicles
      @fleet = current_user.fleet
      return redirect_to choose_method_fleets_path if @fleet.empty?

      @vrn = vrn_search_in_session
      @vrn ? validate_search_params : assign_pagination
    rescue BaseApi::Error400Exception
      return redirect_to remove_vehicles_fleets_path unless params[:page] == 1
    end

    ##
    # Updates session and redirects to the proper page.
    #
    # ==== Path
    #
    #    :POST /manage_vehicles/remove_vehicles
    #
    def submit_remove_vehicles # rubocop:disable Metrics/AbcSize
      update_vehicles_in_session
      redirect_to_proper_page if params[:commit] == 'Continue'
      return if performed?

      update_search_in_session
      redirect_to remove_vehicles_fleets_path(
        page: (params[:commit].to_i.positive? ? params[:commit].to_i : 1), per_page: params[:per_page]
      )
    end

    ##
    # Validates a search form and redirects to proper page.
    #
    # ==== Path
    #
    #    :POST /manage_vehicles/remove_vehicles/vehicle_not_found
    #
    def submit_search
      form = SearchVrnForm.new(params['vrn_search'])
      if form.valid?
        session[:remove_vehicles_vrn_search] = form.vrn
        redirect_to remove_vehicles_fleets_path
      else
        render_vehicle_not_found(form)
      end
    end

    ##
    # Clears search vrn from session and redirects to select vehicles to remove page.
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/remove_vehicles/clear_search
    #
    def clear_search
      session[:remove_vehicles_vrn_search] = nil
      redirect_to remove_vehicles_fleets_path
    end

    ##
    # Renders vehicle not found page.
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/remove_vehicles/vehicle_not_found
    #
    def vehicle_not_found
      @vrn = vrn_search_in_session
    end

    ##
    # Renders confirm to remove vehicle page.
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/remove_vehicles/confirm_remove_vehicle
    #
    def confirm_remove_vehicle
      # renders confirm to remove vehicle page
    end

    ##
    # Removes the vehicle from the fleet if the user confirms this.
    #
    # ==== Path
    #
    #    :DELETE /manage_vehicles/remove_vehicles/confirm_remove_vehicle
    #
    def delete_vehicle # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      form = VehiclesManagement::ConfirmationForm.new(params['confirm-delete'])
      unless form.valid?
        flash.now.alert = confirmation_error(form)
        return render :confirm_remove_vehicle
      end

      if form.confirmed?
        FleetsApi.remove_vehicle_from_fleet(vrn: vehicles_list_in_session.first,
                                            account_id: current_user.account_id)
        flash[:success] =
          I18n.t('vrn_form.messages.single_vrn_removed', vrn: vehicles_list_in_session.first)
        if current_user.fleet.empty?
          redirect_to dashboard_path
        else
          redirect_to fleets_path
        end
      else
        redirect_to edit_fleets_path
      end
    end

    ##
    # Renders confirm to remove vehicles page.
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/remove_vehicles/confirm_remove_vehicles
    #
    def confirm_remove_vehicles
      @vrns_count = vehicles_list_in_session&.count
    end

    ##
    # Makes api call to remove multiple vehicles from fleet.
    #
    # ==== Path
    #
    #    :DELETE /manage_vehicles/remove_vehicles/confirm_remove_vehicles
    #
    def delete_vehicles
      FleetsApi.remove_vehicles_from_fleet(vehicles: vehicles_list_in_session,
                                           account_id: current_user.account_id)
      flash[:success] =
        I18n.t('vrn_form.messages.multiple_vrns_removed', number: vehicles_list_in_session.count)
      if current_user.fleet.empty?
        redirect_to dashboard_path
      else
        redirect_to fleets_path
      end
    end

    ##
    # Renders vehicles to remove details page.
    #
    # ==== Path
    #
    #    :GET /manage_vehicles/remove_vehicles/vehicles_to_remove_details
    #
    def vehicles_to_remove_details
      @vrns = vehicles_list_in_session
    end

    private

    # Check if provided vrn in search is valid and then make api call.
    def validate_search_params
      form = SearchVrnForm.new(@vrn)
      if form.valid?
        assign_pagination(form.vrn)
        redirect_to vehicle_not_found_fleets_path if @pagination.total_vehicles_count.zero?
      else
        render_vrn_search_errors(form)
      end
    end

    # Assigns errors, clear vrn search input and fetch all vehicles.
    def render_vrn_search_errors(form)
      flash.now[:alert] = form.first_error_message if form.first_error_message
      session[:remove_vehicles_vrn_search] = nil
      assign_pagination
    end

    # Make api call to fetch all vehicles for current page number and vrn search.
    def assign_pagination(search = nil)
      @pagination = @fleet.pagination(
        page: (params[:page] || 1).to_i,
        per_page: (params[:per_page] || 10).to_i,
        vrn: search
      )
    end

    # Assigns errors and renders the vehicle not found page.
    def render_vehicle_not_found(form)
      @vrn = form.vrn
      flash.now[:alert] = form.first_error_message
      render :vehicle_not_found
    end

    # The list of vehicles to remove in session.
    def vehicles_list_in_session
      session[:remove_vehicles_list]
    end

    # Vrn search in session.
    def vrn_search_in_session
      session[:remove_vehicles_vrn_search]
    end

    # Updates session to keep checkbox history for all pages.
    def update_vehicles_in_session
      VehiclesManagement::RemoveVehicles::UpdateVehiclesInSession.call(
        session: session, params: permitted_params
      )
    end

    # Updates search history in session.
    def update_search_in_session
      VehiclesManagement::RemoveVehicles::UpdateSearchInSession.call(session: session,
                                                                     params: permitted_params)
    end

    # Redirects to the proper page depends on vehicles size.
    def redirect_to_proper_page
      if vehicles_list_in_session.count == 1
        redirect_to confirm_remove_vehicle_fleets_path
      elsif vehicles_list_in_session.count >= 1
        redirect_to confirm_remove_vehicles_fleets_path
      else
        flash.now[:alert] = I18n.t('remove_vehicles.errors.messages.vrn_missing')
        @fleet = current_user.fleet
        assign_pagination
        render :remove_vehicles
      end
    end

    # Permitted parameters.
    def permitted_params
      params.permit(:authenticity_token, :commit, :all_selected_checkboxes_count, :vrn_search,
                    :vrns_on_page, remove_vehicles: [])
    end
  end
end
