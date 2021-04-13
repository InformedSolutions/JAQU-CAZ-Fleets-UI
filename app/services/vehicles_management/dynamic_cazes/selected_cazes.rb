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
        session[:selected_zones_ids] << SecureRandom.uuid if session[:selected_zones_ids].empty?
        session[:selected_zones_ids]
      end

      private

      # Loads users selected CAZes from session or AccountsApi.
      def load_or_initialize_selected_cazes
        session[:selected_zones_ids] ||= AccountsApi::Users.user(
          account_id: user.account_id,
          account_user_id: user.user_id
        )['uiSelectedCaz'].to_a
      end
    end
  end
end
