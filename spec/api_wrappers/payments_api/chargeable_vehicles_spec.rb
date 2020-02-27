# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsApi.charges' do
  subject(:call) { PaymentsApi.chargeable_vehicles(account_id: id, zone_id: zone_id) }

  let(:id) { SecureRandom.uuid }
  let(:zone_id) { SecureRandom.uuid }
  let(:base_url) { "accounts/#{id}/chargeable-vehicles" }

  before do
    stub_request(:get, /#{base_url}/).to_return(
      status: 200,
      body: read_unparsed_response('chargeable_vehicles.json')
    )
  end

  it 'calls API with proper query data' do
    call
    expect(WebMock).to have_requested(
      :get,
      /#{base_url}\?cleanAirZoneId=#{zone_id}&pageSize=10/
    )
  end

  context 'with vrn and direction' do
    subject(:call) do
      PaymentsApi.chargeable_vehicles(
        account_id: id, zone_id: zone_id, vrn: @vrn, direction: direction
      )
    end

    let(:direction) { 'next' }

    it 'calls API with proper query data' do
      call
      expect(WebMock).to have_requested(
        :get,
        /#{base_url}\?cleanAirZoneId=#{zone_id}&direction=#{direction}&pageSize=10&vrn=#{@vrn}/
      )
    end

    context 'when direction is missing' do
      let(:direction) { nil }

      it 'calls API without vrn and direction' do
        call
        expect(WebMock).to have_requested(
          :get,
          /#{base_url}\?cleanAirZoneId=#{zone_id}&pageSize=10/
        )
      end
    end
  end
end
