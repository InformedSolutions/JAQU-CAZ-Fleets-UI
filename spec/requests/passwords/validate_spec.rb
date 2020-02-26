# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - POST #validate' do
  subject(:http_request) do
    post reset_passwords_path, params: { passwords: { email_address: email_address } }
  end

  let(:email_address) { 'email@example.com' }

  before do
    allow(AccountsApi).to receive(:initiate_password_reset).and_return(true)
  end

  context 'with valid params' do
    it 'returns a redirect to email sent ' do
      expect(http_request).to redirect_to(email_sent_passwords_path)
    end

    it 'calls AccountsApi.initiate_password_reset' do
      expect(AccountsApi)
        .to receive(:initiate_password_reset)
        .with(email: email_address, reset_url: passwords_url)
      http_request
    end
  end

  context 'with invalid params' do
    let(:email_address) { '' }

    it 'renders reset password view' do
      http_request
      expect(response).to render_template('passwords/reset')
    end
  end
end
