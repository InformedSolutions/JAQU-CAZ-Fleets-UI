# frozen_string_literal: true

##
# Controller class for overwriting Devise methods.
#
class SessionsController < Devise::SessionsController
  include CazLock

  before_action :release_lock_on_caz, only: %i[destroy] # rubocop:disable Rails/LexicallyScopedActionFilter
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
