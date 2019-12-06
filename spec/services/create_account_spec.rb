# frozen_string_literal: true

require 'rails_helper'

describe CreateAccount do
  subject(:service) do
    described_class.call(organisations_params: params, company_name: company_name, host: host)
  end

  let(:params) do
    strong_params(
      email: email,
      email_confirmation: email,
      password: password,
      password_confirmation: password
    )
  end
  let(:user) { create_user(email: email, account_name: company_name) }
  let(:email) { 'email@example.com' }
  let(:password) { '8NAOTpMkx2%9' }
  let(:company_name) { 'Mikusek Software' }
  let(:host) { 'www.example.com' }
  let(:valid) { true }

  before do
    allow(EmailAndPasswordForm)
      .to receive(:new)
      .and_return(instance_double(EmailAndPasswordForm, valid?: valid))
    allow(AccountsApi).to receive(:create_organization).and_return(user)
    allow(Sqs::VerificationEmail).to receive(:call).and_return(SecureRandom.uuid)
  end

  it 'returns the user' do
    expect(service).to eq(user)
  end

  it 'calls EmailAndPasswordForm with proper params' do
    expect(EmailAndPasswordForm).to receive(:new).with(params)
    service
  end

  it 'calls AccountsApi.create_organization with proper params' do
    expect(AccountsApi)
      .to receive(:create_organization)
      .with(
        email: email,
        _password: password,
        _company_name: company_name
      )
    service
  end

  context 'when SQS call fails' do
    before do
      allow(Sqs::VerificationEmail).to receive(:call).and_return(false)
    end

    it 'raises API 500 Exception' do
      expect { service }.to raise_error(BaseApi::Error500Exception)
    end
  end
end
