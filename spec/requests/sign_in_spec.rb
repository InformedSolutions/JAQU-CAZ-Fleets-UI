# frozen_string_literal: true

require 'rails_helper'

describe 'User singing in', type: :request do
  let(:email) { 'user@example.com' }
  let(:password) { '12345678' }
  let(:params) do
    {
      user: {
        email: email,
        password: password
      }
    }
  end

  subject(:http_request) { post user_session_path(params) }

  context 'when incorrect credentials given' do
    before { allow(AccountsApi).to receive(:sign_in).and_return(false) }

    it 'calls AccountApi.sign_in with proper params' do
      expect(AccountsApi)
        .to receive(:sign_in)
        .with(email: email, password: password)
      http_request
    end

    it 'shows base error message once' do
      http_request
      expect(response.body.scan(I18n.t('login_form.incorrect')).size).to eq(1)
    end
  end
end
