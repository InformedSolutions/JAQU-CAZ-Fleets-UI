# frozen_string_literal: true

##
# Module used for manage users flow
module Payments
  module MockedResponses
    def mock_chargeable_vehicles
      allow_any_instance_of(Payments::ChargeableVehicles).to receive(:pagination)
        .and_return(paginated_vehicles)
    end

    private

    def paginated_vehicles
      instance_double(Payments::PaginatedVehicles,
                      vehicle_list: mocked_chargeable_vehicles,
                      any_results?: true,
                      all_days_unpaid?: false,
                      page: 1,
                      total_pages: 5,
                      range_start: 1,
                      range_end: 5,
                      total_vehicles_count: 45)
    end

    def mocked_chargeable_vehicles
      vehicles_data = read_response('payments/chargeable_vehicles.json').dig('1', 'chargeableAccountVehicles',
                                                                             'results')
      vehicles_data.map { |vehicle_data| Payments::Vehicle.new(vehicle_data) }
    end
  end
end
