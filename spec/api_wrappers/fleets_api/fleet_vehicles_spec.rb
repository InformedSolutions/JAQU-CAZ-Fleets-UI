# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.job_status' do
  subject(:call) { FleetsApi.fleet_vehicles(account_id: id, page: page) }
  let(:id) { SecureRandom.uuid }
  let(:page) { 5 }

  before do
    stub_request(:get, %r{accounts/#{id}/vehicles}).to_return(
      status: 200,
      body: read_unparsed_response('fleet.json')
    )
  end

  it 'calls API with proper query data' do
    call
    expect(WebMock).to have_requested(
      :get,
      %r{accounts/#{id}/vehicles\?pageNumber=#{page - 1}&pageSize=10}
    )
  end

  it 'returns vrns list' do
    expect(call['vrns']).to be_a(Array)
  end

  context 'with per_page' do
    subject(:call) { FleetsApi.fleet_vehicles(account_id: id, page: page, per_page: per_page) }

    let(:per_page) { 25 }

    it 'calls API with proper query data' do
      call
      expect(WebMock).to have_requested(
        :get,
        %r{accounts/#{id}/vehicles\?pageNumber=#{page - 1}&pageSize=#{per_page}}
      )
    end
  end
end
