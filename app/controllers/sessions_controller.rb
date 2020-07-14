# frozen_string_literal: true

##
# Controller class used to automatically sign out user
#
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :assign_back_button_url, only: :logout_notice

  ##
  # Renders the sign out page
  #
  # ==== Path
  #
  #    :GET /sign-out
  #
  def sign_out_page
    render 'devise/sessions/sign_out'
  end

  ##
  # Renders the logout notice page
  #
  # ==== Path
  #
  #    :GET /logout_notice
  #
  def logout_notice
    @back_button_url = request.referer
    render 'devise/sessions/logout_notice'
  end

  ##
  # Logs out user and redirects him to login page with notice about timeout.
  #
  # ==== Path
  #
  #    :GET /timedout_user
  #
  def timedout_user
    sign_out current_user
    flash[:notice] = I18n.t('inactivity_logout')
    redirect_to new_user_session_path
  end
end
