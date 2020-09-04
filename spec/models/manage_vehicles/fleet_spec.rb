# frozen_string_literal: true

require 'rails_helper'

describe VehiclesManagement::Fleet, type: :model do
  subject(:fleet) { described_class.new(account_id) }

  let(:account_id) { @uuid }

  describe '.pagination' do
    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:vehicles) { subject.pagination(page: page) }
    let(:vehicles_data) { read_response('vehicles.json')[page.to_s] }

    before { allow(FleetsApi).to receive(:vehicles).and_return(vehicles_data) }

    it 'calls FleetsApi.vehicles with proper params' do
      expect(FleetsApi).to(
        receive(:vehicles).with(account_id: account_id, page: page, per_page: per_page)
      )
      vehicles
    end

    it 'returns a VehiclesManagement::PaginatedFleet' do
      expect(vehicles).to be_a(VehiclesManagement::PaginatedFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of vehicles' do
        expect(vehicles.vehicle_list).to all(be_a(VehiclesManagement::Vehicle))
      end
    end

    describe '.total_pages' do
      it 'returns the total pages count value' do
        expect(vehicles.total_pages).to eq(vehicles_data['pageCount'])
      end
    end
  end

  describe '.any_chargeable_vehicles_in_caz?' do
    subject { fleet.any_chargeable_vehicles_in_caz?(zone_id) }

    let(:zone_id) { @uuid }
    let(:data) { read_response('chargeable_vehicles.json') }

    before { allow(PaymentsApi).to receive(:chargeable_vehicles).and_return(data) }

    it 'calls FleetsApi.chargeable_vehicles with proper params' do
      expect(PaymentsApi)
        .to receive(:chargeable_vehicles)
        .with(account_id: account_id, zone_id: zone_id, direction: nil, vrn: nil)
      subject
    end

    context 'when response is not empty' do
      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'when response is empty' do
      let(:data) { {} }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.charges' do
    subject { fleet.charges(zone_id: zone_id) }

    let(:zone_id) { @uuid }
    let(:data) { read_response('chargeable_vehicles.json') }

    before { allow(PaymentsApi).to receive(:chargeable_vehicles).and_return(data) }

    it 'calls FleetsApi.chargeable_vehicles with proper params' do
      expect(PaymentsApi)
        .to receive(:chargeable_vehicles)
        .with(account_id: account_id, zone_id: zone_id, direction: nil, vrn: nil)
      subject
    end

    it 'returns a VehiclesManagement::ChargeableFleet' do
      expect(subject).to be_a(VehiclesManagement::ChargeableFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of VehiclesManagement::ChargeableVehicle instances' do
        expect(subject.vehicle_list).to all(be_a(VehiclesManagement::ChargeableVehicle))
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

    let(:zone_id) { @uuid }
    let(:vrn) { 'PAY001' }
    let(:data) { read_response('chargeable_vehicle.json') }

    before { allow(PaymentsApi).to receive(:chargeable_vehicle).and_return(data) }

    it 'calls FleetsApi.chargeable_vehicles with proper params' do
      expect(PaymentsApi)
        .to receive(:chargeable_vehicle)
        .with(account_id: account_id, zone_id: zone_id, vrn: vrn)
      charges_by_vrn
    end

    it 'returns a VehiclesManagement::ChargeableFleet' do
      expect(charges_by_vrn).to be_a(VehiclesManagement::ChargeableFleet)
    end

    describe '.vehicle_list' do
      it 'returns an list of VehiclesManagement::ChargeableVehicle instances' do
        expect(charges_by_vrn.vehicle_list).to all(be_a(VehiclesManagement::ChargeableVehicle))
      end
    end
  end

  describe '.add_vehicle' do
    before { allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true) }

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      vehicle_type = 'car'
      expect(FleetsApi).to receive(:add_vehicle_to_fleet)
        .with(vrn: @vrn, vehicle_type: vehicle_type, account_id: account_id)
      subject.add_vehicle(@vrn, vehicle_type)
    end
  end

  describe '.empty?' do
    let(:vehicles_data) { read_response('fleet.json') }

    before { allow(FleetsApi).to receive(:fleet_vehicles).and_return(vehicles_data) }

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi).to receive(:fleet_vehicles).with(account_id: account_id, page: 1, per_page: 1)
      subject.empty?
    end

    context 'when some vehicles returned' do
      it 'returns false' do
        expect(subject.empty?).to be_falsey
      end
    end

    context 'when no vehicles returned' do
      let(:vehicles_data) { { 'vrns' => [] } }

      it 'returns true' do
        expect(subject.empty?).to be_truthy
      end
    end
  end

  describe '.delete_vehicle' do
    before { allow(FleetsApi).to receive(:remove_vehicle_from_fleet).and_return(true) }

    it 'calls FleetsApi.remove_vehicle_from_fleet with proper params' do
      expect(FleetsApi).to receive(:remove_vehicle_from_fleet).with(account_id: account_id, vrn: @vrn)
      subject.delete_vehicle(@vrn)
    end
  end

  describe '.total_vehicles_count' do
    let(:vehicles_data) { read_response('fleet.json') }

    before { allow(FleetsApi).to receive(:fleet_vehicles).and_return(vehicles_data) }

    it 'calls AccountsApi.fleet_vehicles with proper params' do
      expect(FleetsApi).to receive(:fleet_vehicles).with(account_id: account_id, page: 1, per_page: 1)
      subject.total_vehicles_count
    end

    context 'when some vehicles returned' do
      it 'returns vehicles count' do
        expect(subject.total_vehicles_count).to eq(23)
      end
    end
  end
end
