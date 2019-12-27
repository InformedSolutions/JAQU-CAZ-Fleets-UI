# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FleetsController - POST #create' do
  subject(:http_request) do
    post fleets_path, params: { 'confirm-vehicle-creation' => confirmation }
  end

  let(:confirmation) { 'yes' }

  before do
    sign_in create_admin
    http_request
  end

  context 'when user confirms form' do
    it 'redirects to enter details page ' do
      expect(response).to redirect_to(enter_details_vehicles_path)
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to dashboard page' do
      expect(response).to redirect_to(dashboard_path)
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'redirects to manage users page' do
      expect(response).to redirect_to(fleets_path)
    end
  end
end
