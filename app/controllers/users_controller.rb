# frozen_string_literal: true

##
# Controller used to manage users
#
class UsersController < BaseController
  before_action -> { check_permissions(allow_manage_users?) }
  ##
  # Renders manage users page
  #
  # ==== Path
  #
  #    GET /users
  #
  def index
    # API Call
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
