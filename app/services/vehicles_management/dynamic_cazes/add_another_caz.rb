# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Module used to manage dynamic cazes selection.
  module DynamicCazes
    ##
    # Service used to add another (empty) CAZ select to session.
    #
    class AddAnotherCaz < Base
      # Initializer function. Used by the class level method +.call+
      #
      # ==== Attributes
      # * +session+ - the user's session
      #
      def initialize(session:)
        @session = session
      end

      # It adds new UUID to create empty select box for another caz.
      def call
        session[:selected_zones_ids] << SecureRandom.uuid
      end
    end
  end
end
