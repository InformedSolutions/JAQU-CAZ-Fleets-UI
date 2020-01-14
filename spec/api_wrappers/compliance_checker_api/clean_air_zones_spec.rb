# frozen_string_literal: true

require 'rails_helper'

describe 'ComplianceCheckerApi.clean_air_zones' do
  subject(:call) { ComplianceCheckerApi.clean_air_zones }

  context 'when call returns 200' do
    before do
      caz_list_response = read_unparsed_response('caz_list.json')
      stub_request(:get, /clean-air-zones/).to_return(
        status: 200,
        body: caz_list_response,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'returns an array of clear air zones' do
      expect(call).to be_a(Array)
    end

    it 'returns proper fields' do
      expect(call.first.keys).to contain_exactly('cleanAirZoneId', 'name', 'boundaryUrl')
    end

    it 'calls API once' do
      call
      expect(WebMock).to have_requested(:get, /clean-air-zones/).once
    end
  end

  context 'when call returns 500' do
    before do
      stub_request(:get, /clean-air-zones/).to_return(
        status: 500,
        body: { 'message' => 'Something went wrong' }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
