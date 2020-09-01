# frozen_string_literal: true

##
# Controller class for overwriting Devise methods.
#
class SessionsController < Devise::SessionsController
  ##
  # Renders login page
  #
  # ==== Path
  #
  #    :GET /users/sign_in
  #
  def new
    super
    session[:reset_password_back_button_url] = new_user_session_path
  end
end
