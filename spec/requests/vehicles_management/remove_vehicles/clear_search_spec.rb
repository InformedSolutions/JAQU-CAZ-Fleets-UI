# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - GET #clear_search', type: :request do
  subject { get clear_search_fleets_path }

  context 'when correct permissions' do
    before do
      sign_in(create_user)
      add_to_session(remove_vehicles_vrn_search: 'ABC123')
      subject
    end

    it 'clears `remove_vehicles_vrn_search` in session' do
      expect(session[:remove_vehicles_vrn_search]).to be_nil
    end

    it 'redirects to remove vehicles page' do
      expect(response).to redirect_to(remove_vehicles_fleets_path)
    end
  end

  it_behaves_like 'incorrect permissions'
end
