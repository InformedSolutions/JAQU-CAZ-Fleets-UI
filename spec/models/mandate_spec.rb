# frozen_string_literal: true

require 'rails_helper'

describe Mandate, type: :model do
  subject(:mandate) { described_class.new(data) }

  let(:data) do
    {
      'zoneId' => zone_id,
      'zoneName' => zone_name,
      'mandateId' => id,
      'status' => 'pending'
    }
  end

  let(:id) { SecureRandom.uuid }
  let(:zone_id) { SecureRandom.uuid }
  let(:zone_name) { 'Leeds' }

  describe '.id' do
    it 'returns ID' do
      expect(mandate.id).to eq(id)
    end
  end

  describe '.status' do
    it 'returns humanized status' do
      expect(mandate.status).to eq('Pending')
    end
  end

  describe '.zone_id' do
    it 'returns ID' do
      expect(mandate.zone_id).to eq(zone_id)
    end
  end

  describe '.zone_name' do
    it 'returns name' do
      expect(mandate.zone_name).to eq(zone_name)
    end
  end
end
