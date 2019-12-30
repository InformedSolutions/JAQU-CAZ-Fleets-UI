# frozen_string_literal: true

module MockFleet
  def mock_empty_fleet
    mock_fleet(instance_double(Fleet, vehicles: [], add_vehicle: true))
  end

  def mock_vehicles_in_fleet
    mock_fleet(instance_double(Fleet, vehicles: vehicles, add_vehicle: true))
  end

  def vehicles
    vehicles_data = read_response('fleet.json')
    vehicles_data.map { |data| Vehicle.new(data) }
  end

  private

  def mock_fleet(fleet_instance)
    allow(Fleet).to receive(:new).and_return(fleet_instance)
  end
end

World(MockFleet)
