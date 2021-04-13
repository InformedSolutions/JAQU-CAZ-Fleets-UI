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
    class RemoveSelectedCaz < Base
      # Initializer function. Used by the class level method +.call+
      #
      # ==== Attributes
      # * +session+ - the user's session
      # * +user+ - the logged in user
      # * +id+ - the id of CAZ to be removed
      #
      def initialize(session:, user:, id:)
        @session = session
        @user = user
        @id = id
      end

      # It removes UUID from the selected caz ids session.
      def call
        return if @id.blank? || session[:selected_zones_ids].exclude?(@id)

        session[:selected_zones_ids].delete(@id)
        update_user_details
      end

      private

      # update user details if needed.
      def update_user_details
        zones = load_zones
        return unless zones.map(&:id).include?(@id)

        ids_to_save_in_api = session[:selected_zones_ids].select { |z| zones.map(&:id).include?(z) }
        update_user_ui_selected_caz(ids_to_save_in_api)
      end
    end
  end
end
