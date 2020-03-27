# frozen_string_literal: true

require 'rails_helper'

describe DirectDebit, type: :model do
  subject(:debit) { described_class.new(account_id) }

  let(:account_id) { SecureRandom.uuid }

  before do
    mock_debits
  end

  describe '.mandates' do
    subject { debit.mandates }

    it 'calls DebitsApi.account_mandates with proper params' do
      expect(DebitsApi).to receive(:mandates).with(account_id: account_id)
      subject
    end

    it 'returns an array of Mandate instances' do
      expect(subject).to all(be_a(Mandate))
    end

    it 'assigns data to mandates' do
      expect(subject.first.zone_id).not_to be_nil
    end
  end

  describe '.active_mandates' do
    subject { debit.active_mandates }

    it 'returns an array of Mandate instances' do
      expect(subject).to all(be_a(Mandate))
    end

    it 'returns only active mandate' do
      expect(subject.size).to eq(1)
    end
  end

  describe '.inactive_mandates' do
    subject { debit.inactive_mandates }

    it 'returns an array of Mandate instances' do
      expect(subject).to all(be_a(Mandate))
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
