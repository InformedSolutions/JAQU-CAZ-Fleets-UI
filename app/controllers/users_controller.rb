# frozen_string_literal: true

##
# Controller used to manage users
#
class UsersController < ApplicationController
  include CheckPermissions

  before_action -> { check_permissions(allow_manage_users?) }
  ##
  # Renders manage users page
  #
  # ==== Path
  #
  #    GET /users
  #
  def index
    api_response = AccountsApi.users(account_id: current_user.account_id)
    @users = api_response.map { |user_data| ManageUsers::User.new(user_data) }
  end

  ##
  # Renders add a user page
  #
  # ==== Path
  #
  #    GET /users/new
  #
  def new
    # Renders add a user page
  end

  ##
  # Process create user request
  #
  # ==== Path
  #
  #    POST /users/create
  #
  def create
    form = NewUserForm.new(current_user.account_id, new_user_params)
    SessionManipulation::SetNewUser.call(session: session, params: new_user_params)
    if form.valid?
      redirect_to add_permissions_users_path
    else
      @errors = form.errors.messages
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
    # Renders add permissions for user page
  end

  private 

  def new_user_params
    params.require(:new_user).permit(:name, :email)
  end
end
