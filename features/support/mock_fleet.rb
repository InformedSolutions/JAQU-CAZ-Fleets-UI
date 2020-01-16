# frozen_string_literal: true

module MockFleet
  def mock_empty_fleet
    mock_fleet
  end

  def mock_vehicles_in_fleet
    mock_fleet(vehicles)
  end

  def vehicles
    vehicles_data = read_response('fleet.json')
    vehicles_data.map { |data| Vehicle.new(data) }
  end

  def mock_unavailable_fleet
    allow(Fleet).to receive(:new).and_raise(BaseApi::Error500Exception.new(503, '', {}))
  end

  private

  def mock_fleet(vehicles = [])
    @fleet = instance_double(Fleet, vehicles: vehicles, add_vehicle: true, delete_vehicle: true)
    allow(Fleet).to receive(:new).and_return(@fleet)
  end
end

World(MockFleet)
