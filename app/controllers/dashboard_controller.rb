# frozen_string_literal: true

class DashboardController < ApplicationController
  include CheckPermissions

  ##
  # Renders the dashboard page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/dashboard
  #
  def index
    clear_input_history
    @vehicles_count = current_user.fleet.total_vehicles_count
    @mandates_present = check_mandates
    @users_present = check_users
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

<<<<<<< HEAD
    UsersManagement::Users.new(account_id: current_user.account_id).filtered.any?
=======
    UsersManagement::Users.new(
      account_id: current_user.account_id,
      user_id: current_user.user_id
    ).filtered.any?
>>>>>>> develop
  end

  # clear user flow history from the session
  def clear_input_history
    session[:vrn] = nil
    session[:confirm_vehicle_creation] = nil
    session[:payment_method] = nil
    session[:submission_method] = nil
    session[:new_payment] = nil
    session[:company_back_link_history] = nil
    session[:user_back_link_history] = nil
  end
end
