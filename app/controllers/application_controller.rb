# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # protects applications against CSRF
  protect_from_forgery prepend: true
  # permits additional parameters before sign in
  before_action :configure_permitted_parameters, if: :devise_controller?
  # checks if a user is logged in
  before_action :authenticate_user!, except: %i[health build_id]

  # rescues from API errors
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              BaseApi::Error404Exception,
              with: :redirect_to_server_unavailable

  # rescues `UserAlreadyConfirmedException` exception
  rescue_from UserAlreadyConfirmedException, with: :redirect_to_sign_in

  # enable basic HTTP authentication on production environment if HTTP_BASIC_PASSWORD variable present
  http_basic_authenticate_with name: ENV['HTTP_BASIC_USER'],
                               password: ENV['HTTP_BASIC_PASSWORD'],
                               except: %i[build_id health],
                               if: -> { Rails.env.production? && ENV['HTTP_BASIC_PASSWORD'].present? }

  ##
  # Health endpoint
  #
  # Used as a health check - returns 200 HTTP status
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

  # Permits additional parameters before sign in
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login_ip])
  end

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

    sign_out current_user
    redirect_to new_user_session_path
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

  # Gets data about the new payment from the session
  def total_to_pay_from_session
    helpers.total_to_pay(helpers.new_payment_data[:details])
  end

  # Checks if the user selected LA
  def check_la
    @zone_id = helpers.new_payment_data[:la_id] || helpers.initiated_payment_data[:la_id]
    redirect_to payments_path unless @zone_id
  end

  # Creates an instance of DirectDebits::Debit class and assign it to +@debit+ variable
  def assign_debit
    @debit = DirectDebits::Debit.new(current_user.account_id)
  end

  # Returns job_id for pending job
  def job_id
    Redis.current.hget(account_id_redis_key, 'job_id')
  end

  # Returns correlation_id for pending job
  def job_correlation_id
    Redis.current.hget(account_id_redis_key, 'correlation_id')
  end

  # Clears pending job data for current user
  def clear_job_data
    Redis.current.del(account_id_redis_key)
  end

  # Returns string, e.g. 'account_id_214e8858-5f61-44be-b17d-571a94bee1b0'
  def account_id_redis_key
    "account_id_#{current_user.account_id}"
  end
end
