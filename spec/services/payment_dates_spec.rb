# frozen_string_literal: true

require 'rails_helper'

describe PaymentDates do
  subject(:service_call) { described_class.call }

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
