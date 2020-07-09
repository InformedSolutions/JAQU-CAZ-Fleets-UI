# frozen_string_literal: true

module FleetsHelper
  # returns true if selected confirm_fleet_check in session equals provided value
  # method used in ManageVehicles::Fleet Check step during Sign up
  def checked_fleet_checked?(value)
    new_account_data[:confirm_fleet_check].to_s == value
  end
end
