# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.create_payment' do
  subject(:call) do
    PaymentsApi.create_payment(
      caz_id: caz_id,
      return_url: return_url,
      user_id: user_id,
      transactions: transactions
    )
  end

  let(:caz_id) { SecureRandom.uuid }
  let(:return_url) { 'http://example.com' }
  let(:user_id) { SecureRandom.uuid }
  let(:transactions) do
    [
      {
        vrn: vrn,
        travel_date: today,
        tariff_code: tariff_code,
        charge: charge
      }
    ]
  end

  let(:today) { Date.current.to_s }
  let(:vrn) { 'CAS134' }
  let(:tariff_code) { 'BCC01-private-car' }
  let(:charge) { 18 }

  let(:mock_path) { '/v1/payments' }

  context 'when the response status is :created (201)' do
    before do
      stub_request(:post, /#{mock_path}/).to_return(
        status: 201,
        body: { 'paymentId' => SecureRandom.uuid, 'nextUrl' => 'http://example.com' }.to_json
      )
    end

    it 'returns proper attributes' do
      expect(call.keys).to contain_exactly('paymentId', 'nextUrl')
    end
  end

  context 'when the response status is :internal_server_error (500)' do
    before do
      stub_request(:post, /#{mock_path}/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
