# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - #index', type: :request do
  subject(:http_request) { get fleets_path }

  before { sign_in create_user }

  context 'with empty fleet' do
    before { mock_fleet(create_empty_fleet) }

    it 'redirects to  #submission_method' do
      http_request
      expect(response).to redirect_to submission_method_fleets_path
    end
  end

  context 'with vehicles in fleet' do
    before do
      mock_fleet
      mock_caz_list
    end

    it 'renders manage vehicles page' do
      http_request
      expect(response).to render_template('fleets/index')
    end

    it 'calls ComplianceCheckerApi.clean_air_zones' do
      expect(ComplianceCheckerApi).to receive(:clean_air_zones)
      http_request
    end

    it 'sets default page value to 1' do
      http_request
      expect(assigns(:vehicles).page).to eq(1)
    end
  end
end
