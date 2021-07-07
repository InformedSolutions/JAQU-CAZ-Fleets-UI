# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - GET #vehicles_to_remove_details', type: :request do
  subject { get vehicles_to_remove_details_fleets_path }

  context 'when correct permissions' do
    before do
      sign_in(create_user)
      add_to_session(remove_vehicles_list: vrns)
      subject
    end

    let(:vrns) { %w[ABC123 XYZ123] }

    it 'returns a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the view' do
      expect(response).to render_template(:vehicles_to_remove_details)
    end

    it 'assigns `vrns` variable' do
      expect(assigns(:vrns)).to eq(vrns)
    end
  end

  it_behaves_like 'incorrect permissions'
end
