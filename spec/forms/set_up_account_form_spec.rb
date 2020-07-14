# frozen_string_literal: true

require 'rails_helper'

describe SetUpAccountForm, type: :model do
  subject(:form) { described_class.new(params: request_params) }

  let(:request_params) do
    {
      token: token,
      password: password,
      password_confirmation: confirmation
    }
  end

  let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
  let(:password) { 'Pa$$w0rd12345' }
  let(:confirmation) { 'Pa$$w0rd12345' }

  context 'when passwords meet requirements and token is valid' do
    before do
      form.valid?
      allow(AccountsApi).to receive(:set_password).and_return(true)
    end

    it { is_expected.to be_valid }

    it 'makes an api call on submit' do
      expect(AccountsApi)
        .to receive(:set_password)
        .with(token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69', password: 'Pa$$w0rd12345')
      form.submit
    end
  end

  context 'when passwords meet requirements and token is missing or invalid' do
    let(:token) { '' }

    before do
      allow(AccountsApi)
        .to receive(:set_password)
        .and_raise(BaseApi::Error400Exception.new(400, '', {}))
    end

    it 'makes an api call on submit that raises an exception' do
      expect(AccountsApi)
        .to receive(:set_password)
        .with(token: '', password: 'Pa$$w0rd12345')
        .and_raise(BaseApi::Error400Exception.new(400, '', {}))
      form.submit
    end

    it 'has correct token error message' do
      form.submit
      error_message = I18n.t('token_form.token_invalid')
      expect(form.errors.messages[:token]).to include(error_message)
    end

    it 'has no password fields errors' do
      expect(form.errors.messages[:password]).to eq([])
      expect(form.errors.messages[:password_confirmation]).to eq([])
    end

    it '.submit is false' do
      expect(form.submit).to eq(false)
    end
  end

  context 'when passwords do not meet requirements' do
    let(:token) { '27978cac-44fa-4d2e-bc9b-54fd12e37c69' }
    let(:password) { 'pass' }
    let(:confirmation) { 'pass' }

    before do
      allow(AccountsApi)
        .to receive(:set_password)
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
    end

    it 'makes an api call on submit that raises an exception' do
      expect(AccountsApi)
        .to receive(:set_password)
        .with(token: '27978cac-44fa-4d2e-bc9b-54fd12e37c69', password: 'pass')
        .and_raise(BaseApi::Error422Exception.new(422, '', {}))
      form.submit
    end

    it 'has correct password fields message' do
      form.submit
      error_message = I18n.t('new_password_form.errors.password_complexity')
      expect(form.errors.messages[:password]).to include(error_message)
      expect(form.errors.messages[:password_confirmation]).to include(error_message)
    end

    it '.submit is false' do
      expect(form.submit).to eq(false)
    end
  end

  context 'when password confirmation is missing' do
    let(:confirmation) { '' }

    before { form.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(form.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('email_and_password_form.password_confirmation_missing')
      expect(form.errors.messages[:password_confirmation]).to include(error_message)
    end
  end

  context 'when password is missing' do
    let(:password) { '' }
    let(:confirmation) { 'Pa$$w0rd12345' }

    before { form.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('email_and_password_form.password_missing')
      expect(form.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(form.errors.messages[:password_confirmation]).to include(error_message)
    end
  end

  context 'when password and confirmation are different' do
    let(:password) { '54321Pa$$w0rd' }
    let(:confirmation) { 'Pa$$w0rd12345' }

    before { form.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(form.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('new_password_form.errors.password_not_equal')
      expect(form.errors.messages[:password_confirmation]).to include(error_message)
    end
  end

  context 'when neither passwords are provided' do
    let(:password) { '' }
    let(:confirmation) { '' }

    before { form.valid? }

    it { is_expected.not_to be_valid }

    it 'has correct password error' do
      error_message = I18n.t('email_and_password_form.password_missing')
      expect(form.errors.messages[:password]).to include(error_message)
    end

    it 'has correct confirmation error' do
      error_message = I18n.t('email_and_password_form.password_confirmation_missing')
      expect(form.errors.messages[:password_confirmation]).to include(error_message)
    end
  end
end
