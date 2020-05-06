# frozen_string_literal: true

require 'rails_helper'

describe CreateAccount do
  subject(:service) do
    described_class.call(company_name: company_name, confirm_fleet_check: confirm_fleet_check)
  end

  let(:company_name) { 'Mikusek Software' }
  let(:confirm_fleet_check) { 'two_or_more' }
  let(:valid) { true }
  let(:errors) { [] }

  context 'when api returns correct response' do
    before do
      allow(CreateAccountForm)
        .to receive(:new)
        .and_return(instance_double(CreateAccountForm, valid?: valid))
      response = read_response('create_account.json')
      allow(AccountsApi).to receive(:create_account).and_return(response)
    end

    it 'returns the String class' do
      expect(service.class).to eq(String)
    end

    it 'calls CreateAccountForm with proper params' do
      expect(CreateAccountForm).to receive(:new).with(company_name: company_name,
                                                      confirm_fleet_check: confirm_fleet_check)
      service
    end

    it 'calls AccountsApi.create_account with proper params' do
      expect(AccountsApi)
        .to receive(:create_account)
        .with(company_name: company_name)
      service
    end
  end

  context 'when api throws exception' do
    before do
      allow(CreateAccountForm)
        .to receive(:new)
        .and_return(instance_double(CreateAccountForm, valid?: valid, errors: errors))
    end

    context 'when confirm_fleet_check is "less_than_two"' do
      let(:confirm_fleet_check) { 'less_than_two' }

      it 'raises `AccountForMultipleVehiclesException` exception with proper errors object' do
        expect { service }.to raise_error(
          AccountForMultipleVehiclesException
        )
      end
    end

    context 'when params are not valid' do
      let(:valid) { false }
      let(:errors) { ActiveModel::Errors.new(['Some error']) }

      it 'raises `InvalidCompanyCreateException` exception with proper errors object' do
        expect { service }.to raise_error(
          InvalidCompanyCreateException
        )
      end
    end
  end

  context 'when api returns 422 status' do
    let(:error_code) { 'duplicate' }

    before do
      allow(CreateAccountForm)
        .to receive(:new)
        .and_return(instance_double(CreateAccountForm, valid?: valid))

      stub_request(:post, /accounts/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "errorCode": error_code
        }.to_json
      )
    end

    context 'when company name is not unique' do
      it 'raises `UnableToCreateAccountException` exception with proper errors object' do
        expect { service }.to raise_error(
          UnableToCreateAccountException, I18n.t('company_name.errors.duplicate')
        )
      end
    end

    context 'when company name has abusive term' do
      let(:error_code) { 'abuse' }

      it 'raises `UnableToCreateAccountException` exception with proper errors object' do
        expect { service }.to raise_error(
          UnableToCreateAccountException, I18n.t('company_name.errors.abuse')
        )
      end
    end
  end
end
