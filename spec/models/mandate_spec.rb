# frozen_string_literal: true

require 'rails_helper'

describe Mandate, type: :model do
  subject(:mandate) { described_class.new(data) }

  let(:data) do
    {
      'cazId' => zone_id,
      'cazName' => zone_name,
      'mandates' => mandates
    }
  end

  let(:mandates) do
    {
      'id' => mandate_id,
      'reference' => reference,
      'status' => status
    }
  end

  let(:zone_id) { SecureRandom.uuid }
  let(:zone_name) { 'Leeds' }
  let(:mandate_id) { SecureRandom.uuid }
  let(:reference) { '1626' }
  let(:status) { 'pending' }

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

  describe '.id' do
    it 'returns ID' do
      expect(mandate.id).to eq(mandate_id)
    end
  end

  describe '.status' do
    it 'returns humanized status' do
      expect(mandate.status).to eq('Pending')
    end
  end
end
