# frozen_string_literal: true

require 'rails_helper'

describe CreateUserAccount do
  subject(:service) do
    described_class.call(organisations_params: params, account_id: account_id, host: host)
  end

  let(:params) do
    strong_params(
      email: email,
      email_confirmation: email,
      password: password,
      password_confirmation: password
    )
  end
  let(:user) { create_admin(email: email) }
  let(:email) { 'email@example.com' }
  let(:password) { '8NAOTpMkx2%9' }
  let(:account_id) { SecureRandom.uuid }
  let(:host) { 'www.example.com' }
  let(:valid) { true }

  context 'when api returns correct response' do
    before do
      allow(EmailAndPasswordForm)
        .to receive(:new)
        .and_return(instance_double(EmailAndPasswordForm, valid?: valid))
      response = read_response('create_user.json')
      allow(AccountsApi).to receive(:create_user).and_return(response)
    end

    it 'returns the User class' do
      expect(service.class).to eq(User)
    end

    it 'calls EmailAndPasswordForm with proper params' do
      expect(EmailAndPasswordForm).to receive(:new).with(params)
      service
    end

    it 'calls AccountsApi.users with proper params' do
      expect(AccountsApi)
        .to receive(:create_user)
        .with(
          account_id: account_id,
          email: email,
          password: password
        )
      service
    end
  end

  context 'when api returns 442 status' do
    let(:error_code) { 'emailNotUnique' }

    before do
      allow(EmailAndPasswordForm)
        .to receive(:new)
        .and_return(instance_double(EmailAndPasswordForm, valid?: valid))

      stub_request(:post, /users/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "errorCode": error_code
        }.to_json
      )
    end

    context 'when email is not unique' do
      it 'raises `NewPasswordException` exception with proper errors object' do
        expect { service }.to raise_error(
          an_instance_of(NewPasswordException)
            .and(having_attributes(errors_object: { email: [I18n.t('email.errors.exists')] }))
        )
      end
    end

    context 'when password is not valid' do
      let(:error_code) { 'passwordNotValid' }

      it 'raises `NewPasswordException` exception with proper errors object' do
        expect { service }.to raise_error(
          an_instance_of(NewPasswordException)
            .and(having_attributes(errors_object: { password: [I18n.t(
              'input_form.errors.password_complexity',
              attribute: 'Password'
            )] }))
        )
      end
    end
  end
end
