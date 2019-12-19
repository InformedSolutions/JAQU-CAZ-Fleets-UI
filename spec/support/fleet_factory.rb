# frozen_string_literal: true

module FleetFactory
  def create_empty_fleet
    instance_double(Fleet, vehicles: [])
  end

  def create_fleet
    instance_double(Fleet, vehicles: vehicles)
  end

  def vehicles
    vehicles_data = read_response('fleet.json')
    vehicles_data.map { |data| Vehicle.new(data) }
  end
end
