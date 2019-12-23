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
    if current_user.admin
      render :admin_dashboard
    else
      render :user_dashboard
    end
  end
end
