# frozen_string_literal: true

# View helpers for remove vehicle flow
module RemoveVehiclesHelper
  def remove_vrn_checked?(vrn)
    session['remove_vehicles_list']&.include?(vrn)
  end

  # Number of selected vrns
  def selected_vrns_count
    session['remove_vehicles_list']&.count
  end
end
