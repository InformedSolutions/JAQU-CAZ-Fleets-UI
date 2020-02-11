# frozen_string_literal: true

require 'rails_helper'

describe Fleet, type: :model do
  subject(:fleet) { described_class.new(account_id) }

  let(:account_id) { SecureRandom.uuid }

  describe '.paginated_vehicles' do
    let(:page) { 1 }
    let(:vehicles) { fleet.paginated_vehicles(page: page) }
    let(:vehicles_data) { read_response('fleet.json')[page.to_s] }

    before do
      allow(FleetsApi)
        .to receive(:fleet_vehicles)
        .and_return(vehicles_data)
    end

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi)
        .to receive(:fleet_vehicles)
        .with(account_id: account_id, page: page)
      vehicles
    end

    it 'returns an OpenStruct' do
      expect(vehicles).to be_a(OpenStruct)
    end

    describe '.vehicle_list' do
      it 'returns an list of vehicles' do
        expect(vehicles.vehicle_list).to all(be_a(Vehicle))
      end
    end

    describe '.page' do
      it 'returns the page value' do
        expect(vehicles.page).to eq(vehicles_data['page'])
      end
    end

    describe '.total_pages' do
      it 'returns the total pages count value' do
        expect(vehicles.total_pages).to eq(vehicles_data['pageCount'])
      end
    end
  end

  describe '.add_vehicle' do
    before do
      allow(FleetsApi)
        .to receive(:add_vehicle_to_fleet)
        .and_return(true)
    end

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi)
        .to receive(:add_vehicle_to_fleet)
        .with(vrn: @vrn, _account_id: account_id)
      fleet.add_vehicle(@vrn)
    end
  end

  describe '.exists?' do
    let(:vehicles_data) { read_response('fleet.json')['1'] }

    before do
      allow(FleetsApi)
        .to receive(:fleet_vehicles)
        .and_return(vehicles_data)
    end

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi)
        .to receive(:fleet_vehicles)
        .with(account_id: account_id, page: 1, per_page: 1)
      fleet.empty?
    end

    context 'when some vehicles returned' do
      it 'returns false' do
        expect(fleet.empty?).to be_falsey
      end
    end

    context 'when no vehicles returned' do
      let(:vehicles_data) { { 'vehicles' => [] } }

      it 'returns true' do
        expect(fleet.empty?).to be_truthy
      end
    end
  end
end
