# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to remove users
  #
  class RemoveUsersController < BaseController
    before_action :authenticate_user!
    before_action -> { check_permissions(allow_manage_users?) }

    ##
    # Renders the user removal confirmation page
    #
    # ==== Path
    #
    #    GET /users/:id/delete
    #
    def delete
      @back_button_url = edit_user_path(account_user_id)
      @user_full_name = session.dig(:edit_user, 'name')
    end
  end
end
