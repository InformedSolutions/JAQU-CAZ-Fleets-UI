# frozen_string_literal: true

require 'rails_helper'

describe ChargeableFleet, type: :model do
  subject(:fleet) { described_class.new(data) }

  let(:first_vrn) { vehicles_data.first['vrn'] }
  let(:last_vrn) { vehicles_data.last['vrn'] }
  let(:vehicles_data) do
    read_response('chargeable_vehicles.json')['chargeableAccountVehicles']['results']
  end

  let(:data) do
    {
      'chargeableAccountVehicles' => { 'results' => vehicles_data },
      'firstVrn' => first_vrn,
      'lastVrn' => last_vrn
    }
  end

  describe '.vehicle_list' do
    it 'returns an array of ChargeableVehicle instances' do
      expect(fleet.vehicle_list).to all(be_a(ChargeableVehicle))
    end

    it 'returns proper number of vehicles' do
      expect(fleet.vehicle_list.size).to eq(vehicles_data.size)
    end
  end

  describe '.first_vrn' do
    it { expect(fleet.first_vrn).to eq(first_vrn) }
  end

  describe '.last_vrn' do
    it { expect(fleet.last_vrn).to eq(last_vrn) }
  end

  describe '.previous_page?' do
    it { expect(fleet.previous_page?).to be_truthy }

    context 'without first_vrn' do
      let(:first_vrn) { nil }

      it { expect(fleet.previous_page?).to be_falsey }
    end
  end

  describe '.next_page?' do
    it { expect(fleet.next_page?).to be_truthy }

    context 'without last_vrn' do
      let(:last_vrn) { nil }

      it { expect(fleet.next_page?).to be_falsey }
    end
  end
end
