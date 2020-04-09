# frozen_string_literal: true

class DashboardController < ApplicationController
  ##
  # Renders the dashboard page.
  #
  # ==== Path
  #
  #    :GET /fleets/organisation-account/dashboard
  #
  def index
    clear_input_history
    @vehicles_present = !current_user.fleet.empty?
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
