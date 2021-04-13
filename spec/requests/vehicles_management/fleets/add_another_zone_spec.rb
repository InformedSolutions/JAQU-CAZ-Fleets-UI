# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #add_another_zone', type: :request do
  subject { get add_another_zone_fleets_path }

  context 'when correct permissions' do
    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is logged in' do
      before do
        sign_in manage_vehicles_user
        allow(VehiclesManagement::DynamicCazes::AddAnotherCaz).to receive(:call).and_return({})
        subject
      end

      it 'redirects to #remove' do
        expect(response).to redirect_to(fleets_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
