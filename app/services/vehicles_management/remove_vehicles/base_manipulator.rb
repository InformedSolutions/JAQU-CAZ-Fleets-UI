# frozen_string_literal: true

# Module used for manage vehicles flow.
module VehiclesManagement
  ##
  # Module used for remove vehicles.
  module RemoveVehicles
    # Base class used to improve session management
    class BaseManipulator < BaseService
      include PaymentsHelper

      def initialize(session:, params: {})
        @session = session
        @params = params
      end

      private

      # Attributes reader
      attr_reader :session, :params
    end
  end
end
