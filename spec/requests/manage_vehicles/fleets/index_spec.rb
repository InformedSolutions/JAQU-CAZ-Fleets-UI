# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - #index', type: :request do
  subject { get fleets_path }

  before { sign_in create_user }

  context 'with empty fleet' do
    before { mock_fleet(create_empty_fleet) }

    it 'redirects to  #submission_method' do
      subject
      expect(response).to redirect_to submission_method_fleets_path
    end
  end

  context 'with vehicles in fleet' do
    before do
      mock_fleet
      mock_caz_list
    end

    it 'renders manage vehicles page' do
      subject
      expect(response).to render_template('fleets/index')
    end

    it 'sets default page value to 1' do
      subject
      expect(assigns(:pagination).page).to eq(1)
    end
  end

  context 'with invalid page' do
    before do
      allow(FleetsApi).to receive(:fleet_vehicles).and_raise(
        BaseApi::Error400Exception.new(422, '', {})
      )
      subject
    end

    it 'redirects to fleets page' do
      expect(response).to redirect_to fleets_path
    end
  end
end
