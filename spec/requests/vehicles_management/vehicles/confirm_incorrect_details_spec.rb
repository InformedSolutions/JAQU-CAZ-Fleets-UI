# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::VehicleController - POST #confirm_incorrect_details', type: :request do
  subject { post incorrect_details_vehicles_path, params: { 'confirm-registration': confirmation } }

  let(:confirmation) { 'yes' }

  context 'when correct permissions' do
    let(:account_id) { SecureRandom.uuid }
    let(:vrn) { 'ABC123' }

    it 'redirects to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before do
        sign_in manage_vehicles_user(account_id: account_id)
        allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
        add_to_session(vrn: vrn)
        subject
      end

      context 'when registration confirmed' do
        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end

        it 'redirects to the manage vehicles page' do
          expect(response).to redirect_to(local_exemptions_vehicles_path)
        end
      end

      context 'when registration not confirmed' do
        let(:confirmation) { nil }

        it 'returns a found response' do
          expect(response).to have_http_status(:ok)
        end

        it 'redirects to the incorrect_details page' do
          expect(response).to render_template(:incorrect_details)
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
