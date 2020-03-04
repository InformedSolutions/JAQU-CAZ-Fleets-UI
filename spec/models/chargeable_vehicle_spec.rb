# frozen_string_literal: true

require 'rails_helper'

describe ChargeableVehicle, type: :model do
  subject(:vehicle) { described_class.new(data) }

  let(:data) do
    {
      'vrn' => vrn,
      'charge' => charge,
      'tariffCode' => tariff
    }
  end

  let(:caz_id) { SecureRandom.uuid }
  let(:vrn) { 'CAS310' }
  let(:tariff) { 'VAN-123' }
  let(:charge) { 12.0 }

  describe '.vrn' do
    it { expect(vehicle.vrn).to eq(vrn) }
  end

  describe '.charge' do
    it { expect(vehicle.charge).to eq(charge) }
  end

  describe '.tariff' do
    it { expect(vehicle.tariff).to eq(tariff) }
  end

  describe '.paid_dates' do
    it 'returns an empty array' do
      expect(vehicle.paid_dates).to eq([])
    end

    context 'with paidDates' do
      let(:dates) { ['2020-02-21'] }
      let(:data) { { 'paidDates' => dates } }

      it 'returns dates' do
        expect(vehicle.paid_dates).to eq(dates)
      end
    end
  end

  describe '.serialize' do
    it 'returns a proper hash' do
      expect(vehicle.serialize).to eq(
        { vrn: vrn, tariff: tariff, charge: charge, dates: [] }
      )
    end
  end
end
