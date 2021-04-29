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
    class SelectedCazes < Base
      # Initializer function. Used by the class level method +.call+
      #
      # ==== Attributes
      # * +session+ - the user's session
      # * +user+ - the logged in user
      #
      def initialize(session:, user:)
        @session = session
        @user = user
      end

      # It adds new UUID to create empty select box for another caz.
      def call
        load_or_initialize_selected_cazes

        # create new empty caz select box if empty.
        if session[:fleet_dynamic_zones].empty?
          session[:fleet_dynamic_zones].merge!({ SecureRandom.uuid => nil })
        end
        session[:fleet_dynamic_zones]
      end

      private

      # Loads users selected CAZes from session or AccountsApi.
      def load_or_initialize_selected_cazes
        session[:fleet_dynamic_zones] ||= load_selected_zones
      end

      # Loads selected zones from the Api
      def user_selected_zones_ids
        AccountsApi::Users.user(
          account_id: user.account_id,
          account_user_id: user.user_id
        )['uiSelectedCaz'].to_a
      end

      # Prepares hash with selected zones
      def load_selected_zones
        user_selected_zones_ids.map do |zone_id|
          [SecureRandom.uuid, zones.find { |zone| zone.id == zone_id }.to_h]
        end.to_h
      end
    end
  end
end
