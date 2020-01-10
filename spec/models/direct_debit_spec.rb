# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectDebit, type: :model do
  subject(:debit) { described_class.new(account_id) }

  let(:account_id) { SecureRandom.uuid }

  describe '.mandates' do
    before do
      mandates_data = read_response('mandates.json')
      allow(DebitsApi)
        .to receive(:account_mandates)
        .and_return(mandates_data)
    end

    it 'calls DebitsApi.account_mandates with proper params' do
      expect(DebitsApi)
        .to receive(:account_mandates)
        .with(account_id: account_id)
      debit.mandates
    end

    it 'returns an array of Mandate instances' do
      expect(debit.mandates).to all(be_a(Mandate))
    end

    it 'assigns data to mandates' do
      expect(debit.mandates.first.id).not_to be_nil
    end
  end

  describe '.add_mandate' do
    let(:zone_id) { SecureRandom.uuid }

    before do
      allow(DebitsApi)
        .to receive(:add_mandate)
        .and_return(true)
    end

    it 'calls DebitsApi.add_mandate with proper params' do
      expect(DebitsApi)
        .to receive(:add_mandate)
        .with(zone_id: zone_id, account_id: account_id)
      debit.add_mandate(zone_id)
    end
  end

  describe '.zones_without_mandate' do
    let(:caz_list) { read_response('caz_list.json')['cleanAirZones'] }
    let(:first_zone_id) { caz_list.first['cleanAirZoneId'] }
    let(:second_zone_id) { caz_list.last['cleanAirZoneId'] }

    before do
      allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
      allow(DebitsApi)
        .to receive(:account_mandates)
        .and_return([{ 'zoneId' => first_zone_id }])
    end

    it 'returns one CAZ' do
      expect(debit.zones_without_mandate.size).to eq(1)
    end

    it 'returns the other zone' do
      expect(debit.zones_without_mandate.first.id).to eq(second_zone_id)
    end

    it 'returns an array of CleanAirZone instances' do
      expect(debit.zones_without_mandate).to all(be_a(CleanAirZone))
    end
  end
end
