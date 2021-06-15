# frozen_string_literal: true

##
# Controller class for overwriting Devise methods.
#
class SessionsController < Devise::SessionsController
  include CazLock

  skip_before_action :check_password_age
  before_action :release_lock_on_caz, only: %i[destroy] # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :remove_timedout_flash_if_present, only: :new

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

  private

  # Removes unncecessary timeout flash message if it's present
  def remove_timedout_flash_if_present
    flash.delete(:alert) if flash[:alert] && flash[:alert] == I18n.t('devise.failure.timeout')
  end
end
