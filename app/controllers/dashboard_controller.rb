# frozen_string_literal: true

class DashboardController < ApplicationController
  include CheckPermissions
  include CazLock

  before_action :clear_input_history, only: :index

  ##
  # Renders the dashboard page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/dashboard
  #
  def index
    @vehicles_count = current_user.fleet.total_vehicles_count
    @mandates_present = check_mandates
    @users_present = check_users
    @days_count = days_to_password_expiry
  end

  private

  # Do not perform api call if user don't have permission
  def check_mandates
    return false unless allow_manage_mandates?

    DirectDebits::Debit.new(current_user.account_id).active_mandates.any?
  end

  # Do not perform api call if user don't have permission
  def check_users
    return false unless allow_manage_users?

    UsersManagement::Users.new(
      account_id: current_user.account_id,
      user_id: current_user.user_id
    ).filtered.any?
  end

  # clear user flow history from the session
  def clear_input_history
    clear_manage_vehicles_history
    clear_make_payment_history
    clear_manage_users_history
    clear_payment_history
  end

  # clear manage vehicles inputs
  def clear_manage_vehicles_history
    session[:submission_method] = nil
    session[:confirm_vehicle_creation] = nil
  end

  # clear make payments inputs and release lock on caz for current user
  def clear_make_payment_history
    release_lock_on_caz
    session[:vrn] = nil
    session[:new_payment] = nil
    session[:payment_method] = nil
  end

  # clear manage users inputs
  def clear_manage_users_history
    session[:new_user] = nil
  end

  # clear payments history back links
  def clear_payment_history
    session[:company_back_link_history] = nil
    session[:user_back_link_history] = nil
  end

  # Sets number of remaining days to password expiry
  # Returns number or nil if password was already changed during existing session
  def days_to_password_expiry
    return if session[:password_updated]

    current_user.days_to_password_expiry
  end
end
