# frozen_string_literal: true

module VehiclesManagement
  ##
  # Module used for remove vehicles flow.
  module RemoveVehicles
    ##
    # Updates session to keep vrn search history for all paginated pages.
    #
    class UpdateSearchInSession < BaseManipulator
      # Depends on params updates session.
      def call
        clear_search if params[:commit] == 'CLEARSEARCH'
        update_search if params[:commit] == 'SEARCH'
      end

      private

      # Clears vrn search in session.
      def clear_search
        session[:remove_vehicles_vrn_search] = nil
      end

      # Updates vrn search in session.
      def update_search
        session[:remove_vehicles_vrn_search] = params[:vrn_search]
      end
    end
  end
end
