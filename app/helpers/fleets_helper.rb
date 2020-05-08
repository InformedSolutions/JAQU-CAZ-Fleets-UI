# frozen_string_literal: true

module FleetsHelper
  def zone_colspan(index)
    index == (@zones.size - 1) ? 2 : 1
  end

  # returns true if selected confirm_fleet_check in session equals provided value
  # method used in Fleet Check step during Sign up
  def checked_fleet_checked?(value)
    new_account_data[:confirm_fleet_check].to_s == value
  end
end
