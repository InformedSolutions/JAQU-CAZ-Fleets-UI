# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::UsersController - POST #confirm_set_up' do
  subject { post confirm_set_up_users_path, params: { account_set_up: request_params } }

  let(:request_params) do
    {
      token: token,
      password: password,
      password_confirmation: confirmation
    }
  end

  let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
  let(:password) { 'Pa$$w0rd123456' }
  let(:confirmation) { 'Pa$$w0rd123456' }

  context 'when provided with correct parameters and valid token' do
    before { allow(AccountsApi).to receive(:set_password).and_return(true) }

    it 'redirects to set up confirmation page' do
      subject
      expect(response).to redirect_to(set_up_confirmation_users_path)
    end
  end

  context 'when provided with same but invalid passwords' do
    let(:password) { 'pass' }
    let(:confirmation) { 'pass' }

    before do
      allow(AccountsApi)
        .to receive(:set_password)
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
      subject
    end

    it 'rerenders the page' do
      expect(response).to render_template('set_up')
    end

    it 'provides proper error messages' do
      errors = {
        token: nil,
        password: I18n.t('new_password_form.errors.password_complexity'),
        password_confirmation: I18n.t('new_password_form.errors.password_complexity')
      }

      expect(flash[:errors]).to eq(errors)
    end
  end

  context 'when provided with valid passwords but outdated token' do
    let(:password) { 'Pa$$w0rd123456' }
    let(:confirmation) { 'Pa$$w0rd123456' }

    before do
      allow(AccountsApi)
        .to receive(:set_password)
        .and_raise(BaseApi::Error400Exception.new(400, '', {}))
      subject
    end

    it 'rerenders the page' do
      expect(response).to render_template('set_up')
    end

    it 'provides proper error messages' do
      errors = {
        token: I18n.t('token_form.token_invalid'),
        password: nil,
        password_confirmation: nil
      }

      expect(flash[:errors]).to eq(errors)
    end
  end

  context 'when provided with valid passwords but non-uuid token' do
    let(:token) { '27978cac-non-uuid-token-54fd12e37c69' }
    let(:password) { 'Pa$$w0rd123456' }
    let(:confirmation) { 'Pa$$w0rd123456' }

    before { subject }

    it 'does not call API' do
      expect(AccountsApi).to_not receive(:set_password)
    end

    it 'rerenders the page' do
      expect(response).to render_template('set_up')
    end

    it 'provides proper error messages' do
      errors = {
        token: I18n.t('token_form.token_invalid'),
        password: nil,
        password_confirmation: nil
      }

      expect(flash[:errors]).to eq(errors)
    end
  end
end
