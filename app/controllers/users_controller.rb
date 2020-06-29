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
    # API Call
  end
end
