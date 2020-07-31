# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :assign_debit, only: :index

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
    @mandates_present = @debit.active_mandates.any?
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

  # Creates an instance of DirectDebit class and assign it to +@debit+ variable
  def assign_debit
    @debit = DirectDebit.new(current_user.account_id)
  end
end
