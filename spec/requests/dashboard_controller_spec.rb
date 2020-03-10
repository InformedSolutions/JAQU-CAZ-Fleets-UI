# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :request do
  describe 'GET #index' do
    subject(:http_request) { get dashboard_path }

    it 'returns redirect to the login page' do
      http_request
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before do
        mock_fleet
        sign_in create_user
      end

      it 'returns http success' do
        http_request
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user login IP does not match request IP' do
      before { sign_in create_user(login_ip: '0.0.0.0') }

      it 'returns a redirect to login page' do
        http_request
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'logs out the user' do
        http_request
        expect(controller.current_user).to be_nil
      end
    end
  end
end
