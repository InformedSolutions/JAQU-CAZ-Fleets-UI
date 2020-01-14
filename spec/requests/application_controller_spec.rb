# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :request do
  describe 'verify_admin' do
    subject { get manage_users_path }

    context 'when user is admin' do
      before do
        sign_in create_admin
        subject
      end

      it 'returns an ok response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      before do
        sign_in create_user
        subject
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
