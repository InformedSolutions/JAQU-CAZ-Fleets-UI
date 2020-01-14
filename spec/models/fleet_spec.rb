# frozen_string_literal: true

require 'rails_helper'

describe Fleet, type: :model do
  subject(:fleet) { described_class.new(account_id) }

  let(:account_id) { SecureRandom.uuid }

  describe '.vehicles' do
    before do
      vehicles_data = read_response('fleet.json')
      allow(FleetsApi)
        .to receive(:fleet_vehicles)
        .and_return(vehicles_data)
    end

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi)
        .to receive(:fleet_vehicles)
        .with(_account_id: account_id)
      fleet.vehicles
    end

    it 'returns an array of Vehicle instances' do
      expect(fleet.vehicles).to all(be_a(Vehicle))
    end

    it 'assigns data to vehicles' do
      expect(fleet.vehicles.first.id).not_to be_nil
    end
  end

  describe '.add_vehicle' do
    let(:vehicle_details) do
      { vrn: 'CAS315' }
    end

    before do
      allow(FleetsApi)
        .to receive(:add_vehicle_to_fleet)
        .and_return(true)
    end

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi)
        .to receive(:add_vehicle_to_fleet)
        .with(details: vehicle_details, _account_id: account_id)
      fleet.add_vehicle(vehicle_details)
    end
  end
end
