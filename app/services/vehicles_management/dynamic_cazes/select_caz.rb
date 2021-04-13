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
    class SelectCaz < Base
      # Initializer function. Used by the class level method +.call+
      #
      # ==== Attributes
      # * +session+ - the user's session
      # * +user+ - the logged in user
      # * +current_id+ - id of CAZ which should be changed
      # * +new_id+ - id of CAZ which should selected
      #
      def initialize(session:, user:, current_id:, new_id:)
        @session = session
        @user = user
        @current_id = current_id
        @new_id = new_id
      end

      # It removes UUID from the selected caz ids session.
      def call
        return if @current_id.blank? || @new_id.blank?

        index_of_current_zone = session[:selected_zones_ids].index(@current_id)
        session[:selected_zones_ids][index_of_current_zone] = @new_id

        zones = load_zones
        ids_to_save_in_api = session[:selected_zones_ids].select { |z| zones.map(&:id).include?(z) }
        update_user_ui_selected_caz(ids_to_save_in_api)
      end
    end
  end
end
