# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - GET #confirm_remove_vehicles', type: :request do
  subject { get confirm_remove_vehicles_fleets_path }

  context 'when correct permissions' do
    before do
      sign_in(create_user)
      add_to_session(remove_vehicles_list: %w[ABC123 XYZ123])
      subject
    end

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:confirm_remove_vehicles)
    end

    it 'assigns `vrns_count` variable' do
      expect(assigns(:vrns_count)).to eq(2)
    end
  end

  it_behaves_like 'incorrect permissions'
end
