# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #remove_selected_zone', type: :request do
  subject { get remove_selected_zone_fleets_path(key: SecureRandom.uuid) }

  context 'when correct permissions' do
    before do
      mock_more_than_3_clean_air_zones
      mock_fleet
      mock_user_details
    end

    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is logged in' do
      before do
        sign_in manage_vehicles_user
        allow(VehiclesManagement::DynamicCazes::RemoveSelectedCaz).to receive(:call).and_return({})
        subject
      end

      it 'redirects to manage vehicles page' do
        expect(response).to redirect_to(fleets_path)
      end

      it 'removes selected key from the session' do
        expect(VehiclesManagement::DynamicCazes::RemoveSelectedCaz).to have_received(:call)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
