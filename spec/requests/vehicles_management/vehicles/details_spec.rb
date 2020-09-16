# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - GET #details' do
  subject { get details_vehicles_path }

  context 'correct permissions' do
    before do
      vehicle_details = read_response('vehicle_details.json')
      allow(ComplianceCheckerApi).to receive(:vehicle_details).with(@vrn).and_return(vehicle_details)
    end

    let(:no_vrn_path) { enter_details_vehicles_path }
    it_behaves_like 'a vrn required view'

    context 'when vehicle is not found' do
      before do
        allow(ComplianceCheckerApi).to receive(:vehicle_details)
          .and_raise(BaseApi::Error404Exception.new(404, '', {}))
        sign_in manage_vehicles_user
        add_to_session(vrn: @vrn)
      end

      it 'redirects to vehicles#not_found' do
        subject
        expect(response).to redirect_to not_found_vehicles_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
