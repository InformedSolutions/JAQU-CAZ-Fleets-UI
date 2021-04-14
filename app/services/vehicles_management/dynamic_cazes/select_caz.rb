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
      # * +key+ - uuid key CAZ select box
      # * +zone_id+ - uuid of selected CAZ
      #
      def initialize(session:, user:, key:, zone_id:)
        @session = session
        @user = user
        @key = key
        @zone_id = zone_id
      end

      # It updates the selected zone for select box
      def call
        return if @key.blank? || @zone_id.blank?

        session[:fleet_dynamic_zones][@key] = selected_zone
        update_user_ui_selected_caz(session[:fleet_dynamic_zones])
      end

      # load selected zone hash
      def selected_zone
        zones.find { |zone| zone.id == @zone_id }.to_h
      end
    end
  end
end
