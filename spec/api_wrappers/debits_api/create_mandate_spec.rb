# frozen_string_literal: true

require 'rails_helper'

describe 'DebitsApi.create_mandate' do
  subject do
    DebitsApi.create_mandate(
      account_id: account_id,
      caz_id: caz_id,
      return_url: return_url
    )
  end

  let(:account_id) { @uuid }
  let(:caz_id) { @uuid }
  let(:return_url) { 'http://example.com' }
  let(:url) { "/payments/accounts/#{account_id}/direct-debit-mandates" }

  context 'when the response status is 201' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 201,
        body: read_unparsed_response('debits/create_mandate.json')
      )
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(
        :post,
        /#{url}/
      )
    end

    it 'returns proper attributes' do
      expect(subject.keys).to contain_exactly('nextUrl', 'cleanAirZoneId')
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 404,
        body: { message: 'Account id not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
