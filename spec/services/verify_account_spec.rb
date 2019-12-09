# frozen_string_literal: true

require 'rails_helper'

describe VerifyAccount do
  subject(:service) { described_class.call(token: token) }

  let(:token) do
    Encryption::Encrypt.call(value: {
                               user_id: user_id,
                               account_id: account_id,
                               created_at: Time.current.iso8601,
                               salt: SecureRandom.uuid
                             })
  end
  let(:user_id) { SecureRandom.uuid }
  let(:account_id) { SecureRandom.uuid }

  before { allow(AccountsApi).to receive(:verify_user).and_return(true) }

  it { is_expected.to be_truthy }

  it 'calls AccountsApi.verify_user with proper params' do
    expect(AccountsApi)
      .to receive(:verify_user)
      .with(_user_id: user_id, _account_id: account_id)
    service
  end

  context 'when token is nil' do
    let(:token) { nil }

    it { is_expected.to be_falsey }

    it 'does not call AccountsApi.verify_user' do
      expect(AccountsApi).not_to receive(:verify_user)
      service
    end
  end

  context 'when token is invalid' do
    let(:token) { 'aaaaa' }

    it { is_expected.to be_falsey }

    it 'does not call AccountsApi.verify_user' do
      expect(AccountsApi).not_to receive(:verify_user)
      service
    end
  end

  context 'when API responds with an error' do
    before do
      allow(AccountsApi)
        .to receive(:verify_user)
        .and_raise(BaseApi::Error404Exception.new(404, 'User ot found', {}))
    end

    it { is_expected.to be_falsey }
  end
end
