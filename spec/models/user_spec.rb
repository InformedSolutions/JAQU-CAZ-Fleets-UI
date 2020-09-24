# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  subject { create_user(account_id: account_id) }

  let(:account_id) { @uuid }

  describe '.fleet' do
    it 'returns a fleet object' do
      expect(subject.fleet).to be_a(VehiclesManagement::Fleet)
    end

    it 'calls VehiclesManagement::Fleet.new with proper params' do
      expect(VehiclesManagement::Fleet).to receive(:new).with(account_id)
      subject.fleet
    end
  end

  describe '.add_vehicle' do
    let(:vrn) { @vrn }
    let(:vehicle_type) { 'car' }

    it 'calls FleetsApi.add_vehicle_to_fleet with proper params' do
      expect(FleetsApi).to receive(:add_vehicle_to_fleet).with(
        vrn: vrn,
        vehicle_type: vehicle_type,
        account_id: account_id
      )

      subject.add_vehicle(vrn, vehicle_type)
    end
  end
end
