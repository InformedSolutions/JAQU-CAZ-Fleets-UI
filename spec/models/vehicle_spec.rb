# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject(:vehicle) { described_class.new(data) }

  let(:data) do
    {
      'vehicleId' => id,
      'vrn' => vrn,
      'type' => type,
      'charges' => {
        'leeds' => leeds_charge,
        'birmingham' => birmingham_charge
      }
    }
  end

  let(:id) { SecureRandom.uuid }
  let(:vrn) { 'CAS310' }
  let(:type) { 'type' }
  let(:leeds_charge) { 12.5 }
  let(:birmingham_charge) { 8 }

  describe '.id' do
    it 'returns ID' do
      expect(vehicle.id).to eq(id)
    end
  end

  describe '.vrn' do
    it 'returns VRN' do
      expect(vehicle.vrn).to eq(vrn)
    end
  end

  describe '.type' do
    it 'returns humanized type' do
      expect(vehicle.type).to eq(type.humanize)
    end

    context 'when there is no type' do
      let(:type) { nil }

      it 'returns unrecognised' do
        expect(vehicle.type).to eq('Unrecognised')
      end
    end
  end

  describe '.charge' do
    it 'returns charge value' do
      expect(vehicle.charge('Leeds')).to eq(leeds_charge)
    end

    context 'when unknown CAZ given' do
      it 'returns zero' do
        expect(vehicle.charge('Random')).to eq(0)
      end
    end
  end

  describe '.formatted_charge' do
    it 'returns formatted charge value' do
      expect(vehicle.formatted_charge('Leeds')).to eq('£12.50')
    end

    context 'when charge is 0' do
      let(:leeds_charge) { 0 }

      it "returns 'No charge'" do
        expect(vehicle.formatted_charge('Leeds')).to eq('No charge')
      end
    end

    context 'when charge is nil' do
      let(:leeds_charge) { nil }

      it "returns 'No charge'" do
        expect(vehicle.formatted_charge('Leeds')).to eq('No charge')
      end
    end
  end
end
