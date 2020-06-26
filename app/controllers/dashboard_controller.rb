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
    @mandates_present = DirectDebit.new(current_user.account_id).active_mandates.any?
    @users_present = AccountsApi.users(account_id: current_user.account_id).any?
  end

  private

  # clear input history from the session
  def clear_input_history
    session[:vrn] = nil
    session[:confirm_vehicle_creation] = nil
    session[:payment_method] = nil
    session[:submission_method] = nil
    session[:new_payment] = nil
  end
end
