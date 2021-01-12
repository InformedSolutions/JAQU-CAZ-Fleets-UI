# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.chargeable_vehicles' do
  subject do
    PaymentsApi.chargeable_vehicles(
      account_id: id,
      zone_id: zone_id,
      page: page,
      per_page: per_page,
      only_chargeable: only_chargeable,
      vrn: nil
    )
  end

  let(:id) { @uuid }
  let(:zone_id) { @uuid }
  let(:page) { 5 }
  let(:per_page) { 10 }
  let(:only_chargeable) { 'false' }
  let(:url) { "accounts/#{id}/chargeable-vehicles" }

  before do
    stub_request(:get, /#{url}/).to_return(
      status: 200,
      body: read_unparsed_response('payments/chargeable_vehicles.json')['1']
    )
  end

  # rubocop:disable Layout/LineLength
  it 'calls API with proper query data' do
    subject
    expect(WebMock).to have_requested(
      :get,
      /#{url}\?cleanAirZoneId=#{zone_id}&onlyChargeable=#{only_chargeable}&pageNumber=#{page - 1}&pageSize=#{per_page}/
    )
  end
  # rubocop:enable Layout/LineLength
end
