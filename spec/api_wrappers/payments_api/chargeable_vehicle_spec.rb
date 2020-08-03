# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.chargeable_vehicle' do
  subject(:call) { PaymentsApi.chargeable_vehicle(account_id: id, zone_id: zone_id, vrn: vrn) }

  let(:id) { SecureRandom.uuid }
  let(:zone_id) { SecureRandom.uuid }
  let(:vrn) { 'PAY001' }
  let(:base_url) { "accounts/#{id}/chargeable-vehicles/#{vrn}" }

  before do
    stub_request(:get, /#{base_url}/).to_return(
      status: 200,
      body: read_unparsed_response('chargeable_vehicle.json')
    )
  end

  it 'calls API with proper query data' do
    call
    expect(WebMock).to have_requested(
      :get,
      /#{base_url}\?cleanAirZoneId=#{zone_id}/
    )
  end
end
