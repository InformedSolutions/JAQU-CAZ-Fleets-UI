# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - #submit_details', type: :request do
  subject(:http_request) do
    post enter_details_vehicles_path, params: { vrn: vrn }
  end

  let(:vrn) { 'ABC123' }

  it 'returns redirect to the login page' do
    http_request
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is logged in' do
    before do
      sign_in create_user
      http_request
    end

    context 'when VrnForm is valid' do
      it 'redirects to #details' do
        expect(response).to redirect_to(details_vehicles_path)
      end

      it 'sets vrn in the session' do
        expect(session[:vrn]).to eq(vrn)
      end
    end

    context 'when VrnForm is NOT valid' do
      let(:vrn) { nil }

      it 'redirects to #confirm_details' do
        expect(response).to render_template(:enter_details)
      end

      it 'assigns @errors' do
        expect(assigns(:errors)).not_to be_nil
      end

      it 'does not set vrn in the session' do
        expect(session[:vrn]).to be_nil
      end
    end
  end
end
