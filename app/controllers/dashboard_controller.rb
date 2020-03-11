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
    @vehicles_present = !current_user.fleet.empty?
  end
end
