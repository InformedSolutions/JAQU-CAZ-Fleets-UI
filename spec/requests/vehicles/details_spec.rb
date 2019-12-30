# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - #details', type: :request do
  subject(:http_request) { get details_vehicles_path }

  before do
    vehicle_details = read_response('vehicle_details.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_details)
      .with(@vrn)
      .and_return(vehicle_details)
  end

  it_behaves_like 'a vrn required view'

  context 'when vehicle is not found' do
    before do
      allow(ComplianceCheckerApi)
        .to receive(:vehicle_details)
        .and_raise(BaseApi::Error404Exception.new(404, '', {}))
      sign_in create_user
      add_to_session(vrn: @vrn)
    end

    it 'redirects to vehicles#not_found' do
      http_request
      expect(response).to redirect_to not_found_vehicles_path
    end
  end
end
