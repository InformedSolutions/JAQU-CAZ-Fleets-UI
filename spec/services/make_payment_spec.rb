# frozen_string_literal: true

require 'rails_helper'

describe MakePayment do
  subject(:call) { described_class.call(payment_data: payment_data, user_id: user_id) }
  let(:payment_data) do
    {
      la_id: caz_id,
      details: {
        'PAY015' => {
          vrn: 'PAY015',
          tariff: 'BCC01-HEAVY GOODS VEHICLE',
          charge: 50.0,
          dates: ['2020-03-04']
        }
      }
    }
  end

  let(:caz_id) { '2b01a50b-72c0-48cc-bce2-136baac42581' }
  let(:user_id) { 'cd319616-ae7d-43f8-87c9-e219252b589a' }

  let(:transformed_data) do
    {
      caz_id: caz_id,
      return_url: 'http://example.com', # update in CAZ-2043
      user_id: user_id,
      transactions: [
        {
          vrn: 'PAY015',
          charge: 50.0,
          travel_date: '2020-03-04',
          tariff_code: 'BCC01-HEAVY GOODS VEHICLE'
        }
      ]
    }
  end

  describe '#call' do
    before do
      allow(PaymentsApi).to receive(:create_payment)
        .with(transformed_data)
        .and_return(nextUrl: 'www.wp.pl')
    end

    it 'calls PaymentsApi#create_payment with transformed parameters' do
      call
      expect(PaymentsApi).to have_received(:create_payment).with(transformed_data)
    end
  end
end
