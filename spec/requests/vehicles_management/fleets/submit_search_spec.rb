# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - POST #submit_details', type: :request do
  subject { post fleets_path, params: { vrn: vrn } }

  let(:vrn) { 'ABC123' }

  context 'when correct permissions' do
    before do
      mock_clean_air_zones
      sign_in manage_vehicles_user
    end

    context 'with valid params' do
      context 'with vrn found' do
        before do
          mock_fleet
          subject
        end

        it 'returns a 302 Found status' do
          expect(response).to have_http_status(:found)
        end

        it 'redirect to fleets with appropriate params' do
          expect(response).to redirect_to(fleets_path(vrn: vrn))
        end
      end

      context 'with vrn not found' do
        before do
          mock_fleet(create_empty_fleet)
          subject
        end

        it 'returns a found response' do
          expect(response).to have_http_status(:found)
        end

        it 'redirects to the vrn not found page' do
          expect(response).to redirect_to(vrn_not_found_fleets_path(vrn: vrn, per_page: 10))
        end
      end
    end

    context 'with an invalid params' do
      before do
        mock_fleet
        subject
      end

      let(:vrn) { '' }

      it 'returns a 302 Found status' do
        expect(response).to have_http_status(:found)
      end

      it 'redirect to fleets with appropriate params' do
        expect(response).to redirect_to(fleets_path(vrn: vrn))
      end

      it 'assigns flash error message' do
        expect(flash[:alert]).to eq('Enter the number plate of the vehicle')
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
