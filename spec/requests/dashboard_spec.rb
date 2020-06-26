# frozen_string_literal: true

require 'rails_helper'

describe DashboardController, type: :request do
  describe 'GET #index' do
    subject { get dashboard_path }

    it 'returns redirect to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before do
        mock_fleet
        mock_debits
        mock_users
        sign_in create_user
      end

      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user login IP does not match request IP' do
      before { sign_in create_user(login_ip: '0.0.0.0') }

      it 'returns a redirect to login page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'logs out the user' do
        subject
        expect(controller.current_user).to be_nil
      end
    end
  end
end
