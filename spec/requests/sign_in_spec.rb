# frozen_string_literal: true

require 'rails_helper'

describe 'User signing in', type: :request do
  subject(:http_request) { post user_session_path(params) }

  let(:email) { 'user@example.com' }
  let(:password) { '12345678' }
  let(:params) { { user: { email: email, password: password } } }

  before { allow(AccountsApi).to receive(:sign_in).and_return(User.new) }

  context 'when correct credentials given' do
    it 'calls AccountApi.sign_in with proper params' do
      expect(AccountsApi)
        .to receive(:sign_in)
        .with(email: email, password: password)
      http_request
    end

    it 'redirects to root path' do
      http_request
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when incorrect credentials given' do
    before { allow(AccountsApi).to receive(:sign_in).and_return(false) }

    it 'renders login view' do
      expect(http_request).to render_template("devise/sessions/new")
    end

    it 'shows base error message once' do
      http_request
      expect(body_scan(I18n.t('login_form.incorrect'))).to eq(1)
    end

    it 'shows email error message once' do
      http_request
      expect(body_scan(I18n.t('login_form.email_missing'))).to eq(1)
    end

    it 'shows password error message once' do
      http_request
      expect(body_scan(I18n.t('login_form.password_missing'))).to eq(1)
    end
  end

  context 'when no email is given' do
    let(:email) { '' }

    it_behaves_like 'an invalid login param'

    it 'shows email error message twice' do
      http_request
      expect(body_scan(I18n.t('login_form.email_missing'))).to eq(2)
    end
  end

  context 'when email is in invalid format' do
    let(:email) { 'test' }

    it_behaves_like 'an invalid login param'

    it 'shows email error message twice' do
      http_request
      expect(body_scan(I18n.t('login_form.invalid_email'))).to eq(2)
    end
  end

  context 'when no password is given' do
    let(:password) { '' }

    it_behaves_like 'an invalid login param'

    it 'shows password error message twice' do
      http_request
      expect(body_scan(I18n.t('login_form.password_missing'))).to eq(2)
    end
  end
end
