# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # protects applications against CSRF
  protect_from_forgery prepend: true
  # checks if a user is logged in
  before_action :authenticate_user!, except: %i[health build_id]
  # saves reference to the request for mocks
  before_action :save_request_for_mocks

  # rescues from API errors
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              BaseApi::Error404Exception,
              with: :redirect_to_server_unavailable

  # rescues `UserAlreadyConfirmedException` exception
  rescue_from UserAlreadyConfirmedException,
              with: :redirect_to_sign_in

  ##
  # Health endpoint
  #
  # Used as a healthcheck - returns 200 HTTP status
  #
  # ==== Path
  #
  #    :GET /health.json
  #
  def health
    render json: 'OK', status: :ok
  end

  ##
  # Build ID endpoint
  #
  # Used by CI to determine if the new version is already deployed.
  # +BUILD_ID+ environment variables is used to set it's value.
  # If nothing is set, returns 'undefined
  #
  # ==== Path
  #
  #    :GET /build_id.json
  #
  def build_id
    render json: ENV.fetch('BUILD_ID', 'undefined'), status: :ok
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_resource_or_scope)
    sign_out_path
  end

  # Logs exception and redirects to sign in page
  def redirect_to_sign_in(exception)
    Rails.logger.error "#{exception.class}: #{exception}"

    request.env['warden'].errors[:base] = [exception.message]
    render 'devise/sessions/new'
  end

  # Adds checking IP to default Devise :authenticate_user!
  def authenticate_user!
    super
    check_ip! if current_user
  end

  # Checks if request's remote IP matches the one set for the user during login
  # If not, it logs out user and redirects to the login page
  def check_ip!
    remote_ip = request.remote_ip
    return if current_user.login_ip == remote_ip

    Rails.logger.warn "User with ip #{remote_ip} tried to access the page as #{current_user.email}"
    sign_out current_user
    redirect_to new_user_session_path
  end

  # It assigns current request to the global variable.
  # It is used for the mocks to have access to the session
  # TODO: SHOULD NOT be present in the final release!!!
  def save_request_for_mocks
    $request = request
  end

  # Returns a single error message from confirmation form
  def confirmation_error(form, field = :confirmation)
    form.errors.messages[field].first
  end

  # Function used as a rescue from API errors.
  # Logs the exception and redirects to ErrorsController#service_unavailable
  def redirect_to_server_unavailable(exception)
    Rails.logger.error "#{exception.class}: #{exception}"

    render template: 'errors/service_unavailable', status: :service_unavailable
  end

  # Assign back button url
  def assign_back_button_url
    @back_button_url = request.referer || root_path
  end
end
