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
      # * +key+ - the key of CAZ in hash to be removed
      #
      def initialize(session:, user:, key:)
        @session = session
        @user = user
        @key = key
      end

      # It removes UUID from the selected caz ids session.
      def call
        return if @key.blank? || session[:fleet_dynamic_zones].keys.exclude?(@key)

        removed_zone_id = session.dig(:fleet_dynamic_zones, @key, 'id')
        session[:fleet_dynamic_zones].except!(@key)

        update_user_ui_selected_caz(session[:fleet_dynamic_zones]) if removed_zone_id.present?
      end
    end
  end
end
