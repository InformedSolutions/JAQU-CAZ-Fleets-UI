# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - GET #vehicle_not_found', type: :request do
  subject { get vehicle_not_found_fleets_path }

  context 'when correct permissions' do
    before do
      sign_in(create_user)
      add_to_session(remove_vehicles_vrn_search: vrn)
      mock_chargeable_vehicles
      subject
    end

    let(:vrn) { 'ABC123' }

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:vehicle_not_found)
    end

    it 'assigns vrn value' do
      expect(assigns(:vrn)).to eq(vrn)
    end
  end

  it_behaves_like 'incorrect permissions'
end
