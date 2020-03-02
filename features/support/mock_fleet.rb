# frozen_string_literal: true

module MockFleet
  def mock_empty_fleet
    mock_fleet
  end

  def mock_vehicles_in_fleet(page = 1)
    mock_fleet(vehicles, page)
  end

  def vehicles
    vehicles_data = read_response('charges.json')['1']['vehicles']
    vehicles_data.map { |data| Vehicle.new(data) }
  end

  def mock_unavailable_fleet
    allow(Fleet).to receive(:new).and_raise(BaseApi::Error500Exception.new(503, '', {}))
  end

  private

  def mock_fleet(vehicles = [], page = 1)
    @fleet = instance_double(Fleet,
                             pagination: paginated_vehicles(vehicles, page),
                             add_vehicle: true,
                             delete_vehicle: true,
                             empty?: vehicles.empty?,
                             charges: mocked_charges)
    allow(Fleet).to receive(:new).and_return(@fleet)
  end

  def paginated_vehicles(vehicles, page)
    instance_double(
      PaginatedFleet,
      vehicle_list: vehicles,
      page: page,
      total_pages: 2,
      range_start: 1,
      range_end: 10,
      total_vehicles_count: 15
    )
  end

  def mocked_charges
    ChargeableFleet.new(read_response('chargeable_vehicles.json'))
  end
end

World(MockFleet)
