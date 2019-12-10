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
  let(:user) { create_admin(email: email, account_name: company_name) }
  let(:email) { 'email@example.com' }
  let(:password) { '8NAOTpMkx2%9' }
  let(:company_name) { 'Mikusek Software' }
  let(:host) { 'www.example.com' }
  let(:valid) { true }

  context 'when api returns correct response' do
    before do
      allow(EmailAndPasswordForm)
        .to receive(:new)
        .and_return(instance_double(EmailAndPasswordForm, valid?: valid))
      response = read_response('create_account.json')
      allow(AccountsApi).to receive(:create_account).and_return(response)
      allow(Sqs::VerificationEmail).to receive(:call).and_return(SecureRandom.uuid)
    end

    it 'returns the User class' do
      expect(service.class).to eq(User)
    end

    it 'calls EmailAndPasswordForm with proper params' do
      expect(EmailAndPasswordForm).to receive(:new).with(params)
      service
    end

    it 'calls AccountsApi.create_account with proper params' do
      expect(AccountsApi)
        .to receive(:create_account)
        .with(
          email: email,
          password: password,
          company_name: company_name
        )
      service
    end
  end

  context 'when api returns 442 status' do
    before do
      allow(EmailAndPasswordForm)
        .to receive(:new)
        .and_return(instance_double(EmailAndPasswordForm, valid?: valid))

      stub_request(:post, /accounts/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "details": %w[emailNotUnique passwordNotValid emailNotValid parameterMissing]
        }.to_json
      )
    end

    it 'raises `NewPasswordException` exception' do
      expect { service }.to raise_error(NewPasswordException)
    end
  end
end
