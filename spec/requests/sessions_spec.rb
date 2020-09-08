# frozen_string_literal: true

require 'rails_helper'

describe 'SessionsController  - DELETE #destroy' do
  subject { delete destroy_user_session_url }

  let(:user) { create_owner }
  let(:caz_id) { SecureRandom.uuid }
  let(:caz_lock_key) { "caz_lock_#{user.account_id}_#{caz_id}" }

  before do
    REDIS.hmset(caz_lock_key,
                'account_id', user.account_id,
                'user_id', user.user_id,
                'caz_id', caz_id,
                'email', user.email)
  end

  context 'when CAZ locked by current user' do
    before do
      sign_in user
      add_to_session(new_payment: { caz_id: caz_id })
      subject
    end

    it 'redirects to sign out page' do
      expect(response).to redirect_to(sign_out_path)
    end

    it 'removes caz lock from redis' do
      expect(REDIS.hget(caz_lock_key, 'caz_id')).to be_nil
    end
  end

  context 'when CAZ locked by another user' do
    before do
      sign_in create_user(user_id: SecureRandom.uuid)
      subject
    end

    it 'redirects to sign out page' do
      expect(response).to redirect_to(sign_out_path)
    end

    it 'not removes caz lock from redis' do
      expect(REDIS.hget(caz_lock_key, 'caz_id')).to_not be_nil
    end
  end
end
