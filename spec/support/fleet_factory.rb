# frozen_string_literal: true

module FleetFactory
  def create_empty_fleet
    create_fleet([])
  end

  def create_fleet(vehicles = mocked_vehicles)
    instance_double(Fleet,
                    paginated_vehicles: paginated_vehicles(vehicles),
                    add_vehicle: true,
                    delete_vehicle: true,
                    empty?: vehicles.empty?)
  end

  def mock_fleet(fleet_instance = create_fleet)
    allow(Fleet).to receive(:new).and_return(fleet_instance)
  end

  private

  def mocked_vehicles
    vehicles_data = read_response('fleet.json')['1']['vehicles']
    vehicles_data.map { |data| Vehicle.new(data) }
  end

  def paginated_vehicles(vehicles)
    OpenStruct.new(
      vehicle_list: vehicles,
      page: 1,
      total_pages: 5
    )
  end
end
