# frozen_string_literal: true

# View helpers for remove vehicles flow.
module RemoveVehiclesHelper
  # Check of vrn was already checked by user.
  def remove_vrn_checked?(vrn)
    session['remove_vehicles_list']&.include?(vrn)
  end

  # Number of selected vrns.
  def selected_vrns_count
    session['remove_vehicles_list']&.count
  end

  # The list of vehicles to remove in session.
  def remove_vehicles_list
    session['remove_vehicles_list']
  end
end
