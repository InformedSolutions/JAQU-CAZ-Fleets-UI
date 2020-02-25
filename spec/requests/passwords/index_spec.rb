# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #index', type: :request do
  subject(:http_request) { get passwords_path(token: token) }

  let(:token) { SecureRandom.uuid }

  before do
    allow(AccountsApi).to receive(:validate_password_reset).and_return(true)
  end

  it 'returns an ok response' do
    http_request
    expect(response).to have_http_status(:ok)
  end

  it 'assigns token' do
    http_request
    expect(assigns(:token)).to eq(token)
  end

  it 'saves the token in the session' do
    http_request
    expect(session[:reset_password_token]).to eq(token)
  end

  it 'calls AccountsApi.validate_password_reset' do
    expect(AccountsApi).to receive(:validate_password_reset).with(token: token)
    http_request
  end

  context 'without the token' do
    let(:token) { nil }

    it 'redirects to invalid page' do
      expect(http_request).to redirect_to(invalid_passwords_path)
    end
  end

  context 'when token is invalid' do
    before do
      allow(AccountsApi)
        .to receive(:validate_password_reset)
        .and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
    end

    it 'redirects to invalid page' do
      expect(http_request).to redirect_to(invalid_passwords_path)
    end
  end
end
