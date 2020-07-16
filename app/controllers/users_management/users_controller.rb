# frozen_string_literal: true

##
# Module used for manage users flow
module UsersManagement
  ##
  # Controller used to manage users
  #
  class UsersController < ApplicationController
    include CheckPermissions
    before_action :authenticate_user!, except: %i[set_up confirm_set_up set_up_confirmation]
    before_action -> { check_permissions(allow_manage_users?) },
                  except: %i[set_up confirm_set_up set_up_confirmation]
    before_action :check_new_user, only: %i[add_permissions confirm_permissions]

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

    ##
    # Renders add a user page
    #
    # ==== Path
    #
    #    GET /users/new
    #
    def new
      @return_url = if AccountsApi.users(account_id: current_user.account_id).any?
                      users_path
                    else
                      root_path
                    end
    end

    ##
    # Process create user request
    #
    # ==== Path
    #
    #    POST /users
    #
    def create # rubocop:disable Metrics/AbcSize
      SessionManipulation::SetNewUser.call(session: session, params: new_user_params)
      form = AddNewUserForm.new(account_id: current_user.account_id, new_user: new_user_data)
      if form.valid?
        redirect_to add_permissions_users_path
      else
        flash.now[:errors] = form.errors.messages
        render :new
      end
    end

    ##
    # Renders add permission for user page
    #
    # ==== Path
    #
    #    GET /users/add-permissions
    #
    def add_permissions
      # Renders add user permissions page
    end

    ##
    # Process confirm user permissions request
    #
    # ==== Path
    #
    #    POST /users/confirm_permissions
    #
    def confirm_permissions
      SessionManipulation::SetNewUserPermissions.call(session: session, params: new_user_permissions_params)
      form = AddNewUserPermissionsForm.new(current_user: current_user, new_user: new_user_data,
                                           verification_url: set_up_users_path)
      handle_permissions_form(form)
    end

    ##
    # Renders confirmation user page
    #
    # ==== Path
    #
    #    GET /users/confirmation
    #
    def confirmation
      @new_user_email = session.dig(:new_user, 'email')
    end

    ##
    # Renders account set up page
    #
    # ==== Path
    #
    #    GET /users/set_up
    #
    def set_up
      # Renders account set up page
    end

    ##
    # Process account set up request
    #
    # ==== Path
    #
    #    POST /users/confirm_set_up
    #
    def confirm_set_up
      parameters = params[:account_set_up].permit(:password, :password_confirmation, :token)
      form = SetUpAccountForm.new(params: parameters)

      if form.valid? && form.submit
        redirect_to set_up_confirmation_users_path
      else
        confirm_set_up_errors(form.errors.messages)
        render :set_up
      end
    end

    ##
    # Renders account set up confirmation page
    #
    # ==== Path
    #
    #    GET /users/set_up_confirmation
    #
    def set_up_confirmation
      # Renders account set up confirmation mockup page
    end

    private
    # Formats account set up page errors
    def confirm_set_up_errors(errors)
      flash.now[:errors] = {
        token: errors[:token].first,
        password: errors[:password].first,
        password_confirmation: errors[:password_confirmation].first
      }
    end

    # Returns new user params
    def new_user_params
      params.require(:new_user).permit(:name, :email)
    end

    # Returns new user permissions params
    def new_user_permissions_params
      return {} unless params[:new_user]

      params.require(:new_user).permit(permissions: [])
    end

    # Returns new user data from session
    def new_user_data
      session.dig(:new_user)
    end

    # Returns new user name from session
    def new_user_name
      session.dig(:new_user, 'name')
    end

    # Returns new user email from session
    def new_user_email
      session.dig(:new_user, 'email')
    end

    # Checks new user data in session, redirect to add new user if data missing
    def check_new_user
      return if new_user_name && new_user_email

      Rails.logger.warn 'New user data is missing in the session. Redirecting to new_user_path'
      redirect_to new_user_path
    end

    # Handle add permissions form for new user
    def handle_permissions_form(form) # rubocop:disable Metrics/AbcSize
      if form.valid?
        form.submit
        redirect_to confirmation_users_path
      elsif form.errors.messages[:email].present?
        flash[:errors] = { email: form.errors.messages[:email] }
        redirect_to new_user_path
      else
        flash.now[:errors] = { permissions: form.errors.messages[:permissions] }
        render :add_permissions
      end
    end

    # Clears new user data in session
    def clear_new_user
      session.delete(:new_user)
    end
  end
end
