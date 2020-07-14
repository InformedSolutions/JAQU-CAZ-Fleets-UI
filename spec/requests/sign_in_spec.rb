# frozen_string_literal: true

require 'rails_helper'

describe 'User signing in' do
  subject { post user_session_path(params) }

  let(:email) { 'user@example.com' }
  let(:password) { '12345678' }
  let(:params) { { user: { email: email, password: password } } }

  before do
    allow(AccountsApi)
      .to receive(:sign_in)
      .and_return(
        'email' => email,
        'accountUserId' => @uuid,
        'accountId' => @uuid,
        'accountName' => 'Royal Mail',
        'owner' => false
      )
  end

  context 'when correct credentials given' do
    it 'calls AccountApi.sign_in with proper params' do
      expect(AccountsApi)
        .to receive(:sign_in)
        .with(email: email, password: password)
      subject
    end

    it 'redirects to root path' do
      subject
      expect(response).to redirect_to(authenticated_root_path)
    end

    it 'sets login IP' do
      subject
      expect(controller.current_user.login_ip).to eq(@remote_ip)
    end
  end

  context 'when incorrect credentials given' do
    before do
      allow(AccountsApi)
        .to receive(:sign_in)
        .and_raise(BaseApi::Error401Exception.new(401, '', {}))
    end

    it 'renders login view' do
      expect(subject).to render_template('devise/sessions/new')
    end

    it 'shows base error message once' do
      subject
      expect(body_scan(I18n.t('login_form.incorrect'))).to eq(1)
    end

    it 'shows email error message once' do
      subject
      expect(body_scan(I18n.t('login_form.email_missing'))).to eq(0)
    end

    it 'shows password error message once' do
      subject
      expect(body_scan(I18n.t('login_form.password_missing'))).to eq(0)
    end
  end

  context 'when unconfirmed email is given' do
    before do
      allow(AccountsApi)
        .to receive(:sign_in)
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
    end

    it 'renders login view' do
      expect(subject).to render_template('devise/sessions/new')
    end

    it 'shows email error message twice' do
      subject
      expect(body_scan(I18n.t('login_form.email_unconfirmed'))).to eq(2)
    end
  end

  context 'when no email is given' do
    let(:email) { '' }

    it_behaves_like 'an invalid login param'

    it 'shows email error message twice' do
      subject
      expect(body_scan(I18n.t('login_form.email_missing'))).to eq(2)
    end
  end

  context 'when email is in invalid format' do
    let(:email) { 'test' }

    it_behaves_like 'an invalid login param'

    it 'shows email error message twice' do
      subject
      expect(body_scan(I18n.t('login_form.invalid_email'))).to eq(2)
    end
  end

  context 'when no password is given' do
    let(:password) { '' }

    it_behaves_like 'an invalid login param'

    it 'shows password error message twice' do
      subject
      expect(body_scan(I18n.t('login_form.password_missing'))).to eq(2)
    end
  end
end
