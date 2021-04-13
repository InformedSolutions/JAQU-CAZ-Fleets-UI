# frozen_string_literal: true

##
# Module used for manage vehicles flow
module VehiclesManagement
  ##
  # Module used to manage dynamic cazes selection.
  module DynamicCazes
    ##
    # Base service used to share common methods for DynamiCazes services
    #
    class Base < BaseService
      private

      # Reader for the shared variables
      attr_reader :session, :user

      # Loads accessible zones for selected users
      def load_zones
        user.beta_tester ? CleanAirZone.all : CleanAirZone.visible_cazes
      end

      # Updates user details in AccountsApi
      def update_user_ui_selected_caz(ui_selected_caz)
        AccountsApi::Users.update_user(
          account_id: user.account_id,
          account_user_id: user.user_id,
          ui_selected_caz: ui_selected_caz
        )
      end
    end
  end
end
