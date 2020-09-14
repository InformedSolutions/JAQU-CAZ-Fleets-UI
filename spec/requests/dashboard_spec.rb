# frozen_string_literal: true

require 'rails_helper'

describe DashboardController do
  describe 'GET #index' do
    subject { get authenticated_root_path }

    it 'returns redirect to the login page' do
      subject
      expect(response).to render_template('devise/sessions/new')
    end

    context 'when user is signed in' do
      before do
        mock_fleet
        mock_users
        mock_debits
        sign_in user
      end

      let(:user) { create_user(permissions: %w[MAKE_PAYMENTS MANAGE_MANDATES MANAGE_VEHICLES MANAGE_USERS]) }

      context 'should clear manage users session' do
        before do
          add_to_session(new_user: { name: user.account_name, email: user.email })
          subject
        end

        it 'clears the session' do
          expect(session[:new_user]).to be_nil
        end
      end

      context 'when CAZ locked by current user' do
        before do
          add_caz_lock_to_redis(user)
          add_to_session(new_payment: { caz_id: caz_id })
          subject
        end

        let(:caz_id) { @uuid }

        it 'removes caz lock from redis' do
          expect(REDIS.hget(caz_lock_redis_key, 'caz_id')).to be_nil
        end
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

    context 'when user enters the Dashboard with an outdated password' do
      before { sign_in create_user(permissions: [], days_to_password_expiry: -2) }

      it 'redirects to edit password page' do
        subject
        expect(response).to redirect_to(edit_passwords_path)
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
