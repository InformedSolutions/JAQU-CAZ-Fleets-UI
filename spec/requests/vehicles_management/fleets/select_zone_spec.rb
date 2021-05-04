# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - POST #select_zone', type: :request do
  subject { post select_zone_fleets_path(key: SecureRandom.uuid, zone_id: SecureRandom.uuid) }

  context 'when correct permissions' do
    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is logged in' do
      before do
        sign_in manage_vehicles_user
        allow(VehiclesManagement::DynamicCazes::SelectCaz).to receive(:call).and_return({})
        subject
      end

      it 'redirects to #remove' do
        expect(response).to redirect_to(fleets_path)
      end

      it 'changes seleced zone in the session' do
        expect(VehiclesManagement::DynamicCazes::SelectCaz).to have_received(:call)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
