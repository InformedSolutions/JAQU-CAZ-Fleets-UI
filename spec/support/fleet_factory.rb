# frozen_string_literal: true

module FleetFactory
  def create_empty_fleet
    create_fleet([])
  end

  def create_fleet(vehicles = mocked_vehicles)
    instance_double(Fleet, vehicles: vehicles, add_vehicle: true, delete_vehicle: true)
  end

  def mocked_vehicles
    vehicles_data = read_response('fleet.json')
    vehicles_data.map { |data| Vehicle.new(data) }
  end

  def mock_fleet(fleet_instance = create_fleet)
    allow(Fleet).to receive(:new).and_return(fleet_instance)
  end
end
