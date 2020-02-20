# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.remove_vehicle_from_fleet' do
  subject(:call) { FleetsApi.remove_vehicle_from_fleet(account_id: id, vrn: @vrn) }
  let(:id) { SecureRandom.uuid }
  let(:url) { %r{accounts/#{id}/vehicles/#{@vrn}} }

  before do
    stub_request(:delete, url).to_return(
      status: 200,
      body: '{}'
    )
  end

  it 'calls API with proper query data' do
    call
    expect(WebMock).to have_requested(:delete, url).with(body: nil)
  end

  it 'returns true' do
    expect(call).to be_truthy
  end
end
