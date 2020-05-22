# frozen_string_literal: true

require 'rails_helper'

describe PaymentDates do
  subject(:service_call) { described_class.call(charge_start_date: charge_start_date) }

  context 'when charge_start_date was before 6 days ago' do
    let(:charge_start_date) { Date.today - 10.days }

    it 'returns next and past dates' do
      expect(service_call.keys).to contain_exactly(:next, :past)
    end

    it 'returns 7 objects in :next block' do
      expect(service_call[:next].size).to eq(7)
    end

    it 'returns 6 objects in :past block' do
      expect(service_call[:past].size).to eq(6)
    end

    it 'returns a proper object' do
      expect(service_call[:next].first).to eq(
        {
          name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
          value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
          today: true
        }
      )
    end
  end

  context 'when charge_start_date was before 3 days ago' do
    let(:charge_start_date) { Date.today - 3.days }

    it 'returns next and past dates' do
      expect(service_call.keys).to contain_exactly(:next, :past)
    end

    it 'returns 7 objects in :next block' do
      expect(service_call[:next].size).to eq(7)
    end

    it 'returns 6 objects in :past block' do
      expect(service_call[:past].size).to eq(3)
    end

    it 'returns a proper object' do
      expect(service_call[:next].first).to eq(
        {
          name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
          value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
          today: true
        }
      )
    end
  end

  context 'when charge_start_date was before today ago' do
    let(:charge_start_date) { Date.today }

    it 'returns next and past dates' do
      expect(service_call.keys).to contain_exactly(:next, :past)
    end

    it 'returns 7 objects in :next block' do
      expect(service_call[:next].size).to eq(7)
    end

    it 'returns 6 objects in :past block' do
      expect(service_call[:past]).to be_empty
    end

    it 'returns a proper object' do
      expect(service_call[:next].first).to eq(
        {
          name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
          value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
          today: true
        }
      )
    end
  end
end
