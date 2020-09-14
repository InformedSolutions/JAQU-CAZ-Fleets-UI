# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - PATCH #update' do
  subject do
    patch passwords_path, params: {
      passwords: { old_password: old_password,
                   password: password,
                   password_confirmation: password_confirmation }
    }
  end

  let(:user_id) { SecureRandom.uuid }
  let(:old_password) { 'old_password12345!' }
  let(:password) { 'new_password12345!' }
  let(:password_confirmation) { 'new_password12345!' }

  context 'when signed in' do
    before { sign_in create_user(user_id: user_id) }

    context 'when correct parameters are provided' do
      before { allow(AccountsApi).to receive(:update_password).and_return(true) }

      it 'redirects to success page' do
        expect(subject).to redirect_to(dashboard_path)
      end

      it 'calls AccountsApi.set_password with right params' do
        expect(AccountsApi).to receive(:update_password).with(
          user_id: user_id,
          old_password: old_password,
          new_password: password
        )
        subject
      end
    end

    context 'when old password is invalid' do
      let(:old_password) { 'invalid_password' }

      before do
        allow(AccountsApi).to receive(:update_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'oldPasswordInvalid')
        )
        subject
      end

      it 'renders :edit' do
        expect(response).to render_template('passwords/edit')
      end

      it 'assigns a proper error message' do
        expect(assigns(:errors)[:old_password]).to include(
          I18n.t('update_password_form.errors.old_password_invalid')
        )
      end
    end

    context 'when new password is not complex enough' do
      let(:password) { '12345' }
      let(:password_confirmation) { '12345' }

      before do
        allow(AccountsApi).to receive(:update_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid')
        )
        subject
      end

      it 'renders :edit' do
        expect(response).to render_template('passwords/edit')
      end

      it 'assigns a proper error message' do
        expect(assigns(:errors)[:password]).to include(I18n.t('new_password_form.errors.password_complexity'))
      end
    end

    context 'when old password is reused' do
      let(:password) { 'new_password1234!' }
      let(:password_confirmation) { 'new_password1234!' }

      before do
        allow(AccountsApi).to receive(:update_password).and_raise(
          BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse')
        )
        subject
      end

      it 'renders :edit' do
        expect(response).to render_template('passwords/edit')
      end

      it 'assigns a proper error message' do
        expect(assigns(:errors)[:password]).to include(I18n.t('update_password_form.errors.password_reused'))
      end
    end

    context 'when fields are missing' do
      let(:old_password) { nil }
      let(:password) { nil }
      let(:password_confirmation) { nil }

      before { subject }

      it 'renders :edit' do
        expect(response).to render_template('passwords/edit')
      end

      it 'does not call AccountsApi.set_password' do
        expect(AccountsApi).not_to receive(:update_password)
      end

      it 'assigns correct error message' do
        expected_error = {
          old_password: ['Enter your old password'],
          password: ['Enter your new password'],
          password_confirmation: ['Confirm your new password']
        }
        expect(assigns(:errors)).to eq(expected_error)
      end
    end
  end

  it_behaves_like 'a login required'
end