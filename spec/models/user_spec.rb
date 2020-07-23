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

  it { is_expected.to delegate_method(:vehicles).to(:fleet) }
  it { is_expected.to delegate_method(:add_vehicle).to(:fleet) }
end
