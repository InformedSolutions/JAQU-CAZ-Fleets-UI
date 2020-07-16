# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to show owner users
  #
  class UsersController < BaseController
    before_action :authenticate_user!
    before_action -> { check_permissions(allow_manage_users?) }

    ##
    # Renders manage users page
    #
    # ==== Path
    #
    #    GET /users
    #
    def index
      clear_new_user if request.referer&.include?(confirmation_users_path)
      api_response = AccountsApi.users(account_id: current_user.account_id)
      @users = api_response.map { |user_data| UsersManagement::User.new(user_data) }
    end

    private

    # Clears new user data in session
    def clear_new_user
      session.delete(:new_user)
    end
  end
end
