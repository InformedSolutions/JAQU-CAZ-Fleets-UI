# frozen_string_literal: true

require 'rails_helper'

describe ManageVehicles::Fleet, type: :model do
  subject(:fleet) { described_class.new(account_id) }

  let(:account_id) { SecureRandom.uuid }

  describe '.pagination' do
    let(:page) { 1 }
    let(:vehicles) { fleet.pagination(page: page) }
    let(:vehicles_data) { read_response('charges.json')[page.to_s] }

    before do
      allow(PaymentsApi)
        .to receive(:charges)
        .and_return(vehicles_data)
    end

    it 'calls FleetsApi.charges with proper params' do
      expect(PaymentsApi)
        .to receive(:charges)
        .with(account_id: account_id, page: page)
      vehicles
    end

    it 'returns a ManageVehicles::PaginatedFleet' do
      expect(vehicles).to be_a(ManageVehicles::PaginatedFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of vehicles' do
        expect(vehicles.vehicle_list).to all(be_a(ManageVehicles::Vehicle))
      end
    end

    describe '.page' do
      it 'returns the page value increased by 1' do
        expect(vehicles.page).to eq(vehicles_data['page'] + 1)
      end
    end

    describe '.total_pages' do
      it 'returns the total pages count value' do
        expect(vehicles.total_pages).to eq(vehicles_data['pageCount'])
      end
    end
  end

  describe '.any_chargeable_vehicles_in_caz?' do
    subject(:any_chargeable_vehicles) { fleet.any_chargeable_vehicles_in_caz?(zone_id) }

    let(:zone_id) { SecureRandom.uuid }
    let(:data) { read_response('chargeable_vehicles.json') }

    before do
      allow(PaymentsApi)
        .to receive(:chargeable_vehicles)
        .and_return(data)
    end

    it 'calls FleetsApi.chargeable_vehicles with proper params' do
      expect(PaymentsApi)
        .to receive(:chargeable_vehicles)
        .with(account_id: account_id, zone_id: zone_id, direction: nil, vrn: nil)
      any_chargeable_vehicles
    end

    context 'when response is not empty' do
      it 'returns true' do
        expect(any_chargeable_vehicles).to be_truthy
      end
    end

    context 'when response is empty' do
      let(:data) { {} }

      it 'returns false' do
        expect(any_chargeable_vehicles).to be_falsey
      end
    end
  end

  describe '.charges' do
    subject(:charges) { fleet.charges(zone_id: zone_id) }

    let(:zone_id) { SecureRandom.uuid }
    let(:data) { read_response('chargeable_vehicles.json') }

    before do
      allow(PaymentsApi)
        .to receive(:chargeable_vehicles)
        .and_return(data)
    end

    it 'calls FleetsApi.chargeable_vehicles with proper params' do
      expect(PaymentsApi)
        .to receive(:chargeable_vehicles)
        .with(account_id: account_id, zone_id: zone_id, direction: nil, vrn: nil)
      charges
    end

    it 'returns a ManageVehicles::ChargeableFleet' do
      expect(charges).to be_a(ManageVehicles::ChargeableFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of ManageVehicles::ChargeableVehicle instances' do
        expect(charges.vehicle_list).to all(be_a(ManageVehicles::ChargeableVehicle))
      end
    end

    context 'with vrn and direction' do
      subject(:charges) { fleet.charges(zone_id: zone_id, vrn: @vrn, direction: direction) }

      let(:direction) { 'next' }

      it 'calls FleetsApi.chargeable_vehicles with proper params' do
        expect(PaymentsApi)
          .to receive(:chargeable_vehicles)
          .with(account_id: account_id, zone_id: zone_id, direction: direction, vrn: @vrn)
        charges
      end
    end
  end

  describe '.charges_by_vrn' do
    subject(:charges_by_vrn) { fleet.charges_by_vrn(zone_id: zone_id, vrn: vrn) }

    let(:zone_id) { SecureRandom.uuid }
    let(:vrn) { 'PAY001' }
    let(:data) { read_response('chargeable_vehicle.json') }

    before do
      allow(PaymentsApi)
        .to receive(:chargeable_vehicle)
        .and_return(data)
    end

    it 'calls FleetsApi.chargeable_vehicles with proper params' do
      expect(PaymentsApi)
        .to receive(:chargeable_vehicle)
        .with(account_id: account_id, zone_id: zone_id, vrn: vrn)
      charges_by_vrn
    end

    it 'returns a ManageVehicles::ChargeableFleet' do
      expect(charges_by_vrn).to be_a(ManageVehicles::ChargeableFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of ManageVehicles::ChargeableVehicle instances' do
        expect(charges_by_vrn.vehicle_list).to all(be_a(ManageVehicles::ChargeableVehicle))
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
        .with(vrn: @vrn, account_id: account_id)
      fleet.add_vehicle(@vrn)
    end
  end

  describe '.empty?' do
    let(:vehicles_data) { read_response('fleet.json') }

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
      let(:vehicles_data) { { 'vrns' => [] } }

      it 'returns true' do
        expect(fleet.empty?).to be_truthy
      end
    end
  end

  describe '.delete_vehicle' do
    before do
      allow(FleetsApi)
        .to receive(:remove_vehicle_from_fleet)
        .and_return(true)
    end

    it 'calls FleetsApi.remove_vehicle_from_fleet with proper params' do
      expect(FleetsApi)
        .to receive(:remove_vehicle_from_fleet)
        .with(account_id: account_id, vrn: @vrn)
      fleet.delete_vehicle(@vrn)
    end
  end

  describe '.total_vehicles_count' do
    let(:vehicles_data) { read_response('fleet.json') }

    before do
      allow(FleetsApi)
        .to receive(:fleet_vehicles)
        .and_return(vehicles_data)
    end

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi)
        .to receive(:fleet_vehicles)
        .with(account_id: account_id, page: 1, per_page: 1)
      fleet.total_vehicles_count
    end

    context 'when some vehicles returned' do
      it 'returns vehicles count' do
        expect(fleet.total_vehicles_count).to eq(23)
      end
    end
  end
end
