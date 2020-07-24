# frozen_string_literal: true

##
# Controller class used to automatically sign out user
#
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :timeout_return_page

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
  # Stores page to which user should be taken back after clicking `Continue` on the logout notice page.
  #
  # ==== Path
  #
  #     :POST /timeout_return_page
  #
  def timeout_return_page
    session[:timeout_return_page] = params[:timeout_return_path]
    head :no_content
  end

  ##
  # Renders the logout notice page
  #
  # ==== Path
  #
  #    :GET /logout_notice
  #
  def logout_notice
    @back_button_url = session[:timeout_return_page]
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
    sign_out(current_user)
    flash[:notice] = I18n.t('inactivity_logout')
    redirect_to new_user_session_path
  end
end
