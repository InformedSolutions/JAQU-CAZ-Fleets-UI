# frozen_string_literal: true

##
# Module used for account details management
module AccountDetails
  ##
  # Controller used to update password for primary and non-primary users
  #
  class PasswordsController < ApplicationController
    include CheckPermissions

    before_action :check_edit_request_path, only: :edit

    ##
    # Renders the update password page
    #
    # ==== Path
    #
    #    :GET /primary_users/edit_password
    #    :GET /non_primary_users/edit_password
    #
    def edit
      # renders the update password page
    end

    private

    def check_edit_request_path
      if current_user.owner
        check_permissions(request.path.include?(edit_password_primary_users_path))
      else
        check_permissions(request.path.include?(edit_password_non_primary_users_path))
      end
    end
  end
end
