# frozen_string_literal: true

module FleetsHelper
  def zone_colspan(index)
    index == (@zones.size - 1) ? 2 : 1
  end

  def checked_fleet_checked?(value)
    session.dig('new_account', 'confirm_fleet_check').to_s == value
  end
end
