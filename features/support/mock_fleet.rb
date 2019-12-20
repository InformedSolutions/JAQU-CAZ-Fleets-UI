# frozen_string_literal: true

module MockFleet
  def mock_empty_fleet
    allow(Fleet).to receive(:new).and_return(instance_double(Fleet, vehicles: []))
  end

  def mock_vehicles_in_fleet
    allow(Fleet).to receive(:new).and_return(instance_double(Fleet, vehicles: vehicles))
  end

  def vehicles
    vehicles_data = read_response('fleet.json')
    vehicles_data.map { |data| Vehicle.new(data) }
  end
end

World(MockFleet)
