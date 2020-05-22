# frozen_string_literal: true

require 'rails_helper'

describe CleanAirZone, type: :model do
  subject(:caz) { described_class.new(data) }

  let(:data) do
    {
      'name' => name,
      'cleanAirZoneId' => id,
      'boundaryUrl' => url,
      'exemptionUrl' => url,
      'activeChargeStartDate' => active_charge_start_date
    }
  end
  let(:name) { 'Birmingham' }
  let(:id) { 'a49afb83-d1b3-48b6-b08b-5db8142045dc' }
  let(:url) { 'www.example.com' }
  let(:active_charge_start_date) { '2020-05-14' }

  describe '.id' do
    it 'returns a proper id' do
      expect(caz.id).to eq(id)
    end
  end

  describe '.name' do
    it 'returns a proper name' do
      expect(caz.name).to eq(name)
    end
  end

  describe '.boundary_url' do
    it 'returns a proper url' do
      expect(caz.boundary_url).to eq(url)
    end
  end

  describe '.exemption_url' do
    it 'returns a proper url' do
      expect(caz.exemption_url).to eq(url)
    end
  end

  describe '.active_charge_start_date' do
    it 'returns a proper date active_charge_start_date' do
      expect(caz.active_charge_start_date).to eq(Date.parse(active_charge_start_date))
    end
  end

  describe '.checked?' do
    it 'returns true' do
      expect(caz.checked?([id])).to eq(true)
    end

    context 'when another caz was selected' do
      let(:another_id) { SecureRandom.uuid }

      it 'returns false' do
        expect(caz.checked?([another_id])).to eq(false)
      end
    end
  end

  describe '.all' do
    subject(:zones) { described_class.all }

    before do
      caz_list = read_response('caz_list.json')['cleanAirZones']
      allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
    end

    it 'returns an array of CleanAirZone instances' do
      expect(zones).to all(be_a(CleanAirZone))
    end

    it 'returns only active CleanAirZone' do
      expect(zones.count).to eq(2)
    end
  end

  describe '.active' do
    subject(:zones) { described_class.active }

    before do
      caz_list = read_response('caz_list_active.json')['cleanAirZones']
      allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list)
      CleanAirZone.remove_instance_variable :@all if CleanAirZone.instance_variable_defined? :@all
    end

    after do
      CleanAirZone.remove_instance_variable :@all if CleanAirZone.instance_variable_defined? :@all
    end

    it 'returns an array of CleanAirZone instances' do
      expect(zones).to all(be_a(CleanAirZone))
    end

    it 'returns only active CleanAirZone' do
      expect(zones.count).to eq(1)
    end
  end
end
