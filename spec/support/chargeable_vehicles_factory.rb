# frozen_string_literal: true

module ChargeableVehiclesFactory
  def create_chargeable_vehicles(vehicles = mocked_chargeable_vehicles)
    instance_double(VehiclesManagement::Fleet, charges: vehicles)
  end

  private

  def mocked_chargeable_vehicles
    VehiclesManagement::ChargeableFleet.new(read_response('chargeable_vehicles.json'))
  end
end
