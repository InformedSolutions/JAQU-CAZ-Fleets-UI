# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VehiclesController - POST #confirm_not_found', type: :request do
  subject(:http_request) do
    post confirm_not_found_vehicles_path,
         params: { 'confirm-registration': confirmation }
  end

  let(:confirmation) { 'yes' }
  let(:account_id) { SecureRandom.uuid }

  it 'returns redirect to the login page' do
    http_request
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is signed in' do
    before do
      sign_in create_user(account_id: account_id)
      allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
      add_to_session(vrn: @vrn)
      http_request
    end

    context 'when registration confirmed' do
      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to manage vehicles page' do
        expect(response).to redirect_to(fleets_path)
      end
    end

    context 'when registration not confirmed' do
      let(:confirmation) { nil }

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to not_found page' do
        expect(response).to redirect_to(not_found_vehicles_path)
      end
    end
  end
end
