# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :request do
  describe 'GET #index' do
    subject(:http_request) { get dashboard_path }

    it 'returns redirect to the login page' do
      http_request
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before { sign_in create_user }

      it 'returns http success' do
        http_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end
