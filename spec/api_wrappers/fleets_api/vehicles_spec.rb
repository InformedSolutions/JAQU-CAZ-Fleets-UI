# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.vehicles' do
  subject { FleetsApi.vehicles(account_id: id, page: page, per_page: per_page) }

  let(:id) { @uuid }
  let(:page) { 5 }
  let(:per_page) { 10 }

  before do
    stub_request(:get, %r{accounts/#{id}/vehicles}).to_return(
      status: 200,
      body: read_unparsed_response('vehicles_management/vehicles.json')
    )
  end

  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(
      :get,
      %r{accounts/#{id}/vehicles\?pageNumber=#{page - 1}&pageSize=#{per_page}}
    )
  end
end
