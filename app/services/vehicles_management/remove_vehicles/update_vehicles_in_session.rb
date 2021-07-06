# frozen_string_literal: true

##
# Module used for manage vehicles flow.
module VehiclesManagement
  ##
  # Module used for remove vehicles flow.
  module RemoveVehicles
    ##
    # Updates session to keep checkbox history for all paginated pages.
    #
    class UpdateVehiclesInSession < BaseManipulator
      # Updates +remove_vehicles_list+ in session.
      def call
        delete_from_session
        checked_vrns.each { |vrn| add_to_session(vrn) }
      end

      private

      # Delete vrns from session if vrns was unchecked on current page.
      def delete_from_session
        vrns_to_delete = vrns_on_page.difference(checked_vrns)
        vrns_in_session.delete_if do |vrn|
          vrns_to_delete.include?(vrn)
        end
      end

      # Add vrns from params to session on current page.
      def add_to_session(vrn)
        return if vrns_in_session.include?(vrn)

        vrns_in_session << vrn
      end

      # The list of vrns in session.
      def vrns_in_session
        session[:remove_vehicles_list] ||= []
      end

      # The list of checked vrns.
      def checked_vrns
        params['remove_vehicles'] || []
      end

      # The list of all vrns on current page.
      def vrns_on_page
        params['vrns_on_page']&.split(' ') || []
      end
    end
  end
end
