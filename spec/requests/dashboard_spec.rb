# frozen_string_literal: true

require 'rails_helper'

describe DashboardController do
  describe 'GET #index' do
    subject { get dashboard_path }

    it 'returns redirect to the login page' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'when CAZ locked by current user' do
      before do
        mock_fleet
        add_caz_lock_to_redis(user.user_id)
        sign_in user
        add_to_session(new_payment: { caz_id: caz_id })
        subject
      end

      let(:user) { make_payments_user }
      let(:caz_lock_key) { "caz_lock_#{user.account_id}_#{caz_id}" }
      let(:caz_id) { @uuid }

      it 'removes caz lock from redis' do
        expect(REDIS.hget(caz_lock_key, 'caz_id')).to be_nil
      end
    end

    context 'when user is signed in with password that is about to expire in 8 days' do
      before do
        mock_fleet
        sign_in create_user(
          permissions: [],
          days_to_password_expiry: 8
        )
      end

      it 'returns http success' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'assigns @days_count variable' do
        subject
        expect(assigns(:days_count)).to eq(8)
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
