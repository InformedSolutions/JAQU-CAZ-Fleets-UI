# frozen_string_literal: true

##
# Module used for manage vehicles flow
module RemoveVehicles
  def mock_delete_single_vrn
    allow(FleetsApi).to receive(:remove_vehicle_from_fleet).and_return(true)
  end

  def mock_delete_multiple_vrns
    allow(FleetsApi).to receive(:remove_vehicles_from_fleet).and_return(true)
  end

  def mock_last_vehicle_in_fleet
    mock_fleet(last_vehicle, 1, 1)
  end

  private

  def last_vehicle
    vehicles_data = read_response('/vehicles_management/one_vehicle.json')['vehicles']
    vehicles_data.map { |data| VehiclesManagement::Vehicle.new(data) }
  end
end

World(RemoveVehicles)
