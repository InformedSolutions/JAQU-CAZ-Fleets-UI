# frozen_string_literal: true

require 'rails_helper'

describe DirectDebits::Debit, type: :model do
  subject(:debit) { described_class.new(account_id) }

  let(:account_id) { @uuid }

  before { mock_debits }

  describe '.mandates' do
    subject { debit.mandates }

    it 'calls DebitsApi.account_mandates with proper params' do
      expect(DebitsApi).to receive(:mandates).with(account_id: account_id)
      subject
    end

    it 'returns an array of DirectDebits::Mandate instances' do
      expect(subject).to all(be_a(DirectDebits::Mandate))
    end

    it 'assigns data to mandates' do
      expect(subject.first.zone_id).not_to be_nil
    end
  end

  describe '.caz_mandates' do
    subject { debit.caz_mandates(zone_id) }

    let(:zone_id) { @uuid }

    before { mock_caz_mandates('caz_mandates') }

    it 'calls DebitsApi.caz_mandates with proper params' do
      expect(DebitsApi).to receive(:caz_mandates).with(account_id: account_id, zone_id: zone_id)
      subject
    end

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end

    it 'returns the active mandate' do
      expect(subject['status']).to eq('active')
    end
  end

  describe '.active_mandates' do
    subject { debit.active_mandates }

    it 'returns an array of DirectDebits::Mandate instances' do
      expect(subject).to all(be_a(DirectDebits::Mandate))
    end

    it 'returns only active mandate' do
      expect(subject.size).to eq(1)
    end
  end

  describe '.inactive_mandates' do
    subject { debit.inactive_mandates }

    it 'returns an array of DirectDebits::Mandate instances' do
      expect(subject).to all(be_a(DirectDebits::Mandate))
    end

    it 'returns only zone_id' do
      expect(subject.first.zone_id).not_to be_nil
    end

    it 'returns only caz_name' do
      expect(subject.first.zone_name).not_to be_nil
    end

    it 'returns only inactive mandate' do
      expect(subject.size).to eq(1)
    end
  end
end
