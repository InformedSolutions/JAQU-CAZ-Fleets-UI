# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - POST #submit_search', type: :request do
  subject { post vehicle_not_found_fleets_path, params: { vrn_search: vrn } }

  let(:vrn) { 'ABC123' }

  context 'when correct permissions' do
    before do
      sign_in(create_user)
      add_to_session(remove_vehicles_vrn_search: vrn)
      mock_chargeable_vehicles
      subject
    end

    context 'with valid params' do
      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to remove vehicles page' do
        expect(response).to redirect_to(remove_vehicles_fleets_path)
      end

      it 'assigns `remove_vehicles_vrn_search` to the session' do
        expect(session[:remove_vehicles_vrn_search]).to eq(vrn)
      end
    end

    context 'with an invalid params' do
      let(:vrn) { 'ABCDE$%' }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view' do
        expect(response).to render_template(:vehicle_not_found)
      end

      it 'assigns flash error message' do
        expect(flash[:alert]).to eq('Enter the number plate of the vehicle in a valid format')
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
