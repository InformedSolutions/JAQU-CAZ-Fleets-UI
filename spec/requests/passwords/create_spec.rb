# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - POST #create' do
  subject do
    post passwords_path, params: {
      token: token, passwords: { password: password, password_confirmation: confirmation }
    }
  end

  let(:token) { SecureRandom.uuid }
  let(:password) { 'password' }
  let(:confirmation) { password }

  context 'without token in the session' do
    it 'redirect to invalid page' do
      expect(subject).to redirect_to(invalid_passwords_path)
    end
  end

  context 'with a valid token in the session' do
    before do
      add_to_session(reset_password_token: token)
      allow(AccountsApi).to receive(:set_password).and_return(true)
    end

    it 'redirects to success page' do
      expect(subject).to redirect_to(success_passwords_path)
    end

    it 'calls AccountsApi.set_password with right params' do
      expect(AccountsApi).to receive(:set_password).with(token: token, password: password)
      subject
    end

    it 'clears the token' do
      subject
      expect(session[:reset_password_token]).to be_nil
    end

    context 'when password confirmation is different' do
      let(:confirmation) { 'different_password' }

      it 'renders :index' do
        subject
        expect(response).to render_template('passwords/index')
      end

      it 'does not call AccountsApi.set_password' do
        expect(AccountsApi).not_to receive(:set_password)
        subject
      end

      it 'assigns token' do
        subject
        expect(assigns(:token)).to eq(token)
      end

      it 'does not clear the token' do
        subject
        expect(session[:reset_password_token]).to eq(token)
      end
    end

    context 'when password is not complex enough' do
      before do
        allow(AccountsApi).to receive(:set_password).and_raise(
          BaseApi::Error422Exception.new(422, '', {})
        )
      end

      it 'renders :index' do
        subject
        expect(response).to render_template('passwords/index')
      end

      it 'calls AccountsApi.set_password with right params' do
        expect(AccountsApi).to receive(:set_password).with(token: token, password: password)
        subject
      end

      it 'assigns token' do
        subject
        expect(assigns(:token)).to eq(token)
      end

      it 'does not clear the token' do
        subject
        expect(session[:reset_password_token]).to eq(token)
      end

      it 'assigns a proper error message' do
        subject
        expect(assigns(:errors)[:password]).to include(
          I18n.t('input_form.errors.password_complexity', attribute: 'Password')
        )
      end
    end

    context 'when token is invalid' do
      before do
        allow(AccountsApi).to receive(:set_password).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
      end

      it 'clears the token' do
        subject
        expect(session[:reset_password_token]).to be_nil
      end

      it 'redirect to invalid page' do
        expect(subject).to redirect_to(invalid_passwords_path)
      end
    end
  end

  context 'with a different token in the session' do
    before do
      add_to_session(reset_password_token: SecureRandom.uuid)
    end

    it 'redirect to invalid page' do
      expect(subject).to redirect_to(invalid_passwords_path)
    end
  end
end
