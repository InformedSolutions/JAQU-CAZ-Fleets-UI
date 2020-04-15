# frozen_string_literal: true

require 'rails_helper'

describe CreateAccount do
  subject(:service) do
    described_class.call(company_name: company_name)
  end

  let(:company_name) { 'Mikusek Software' }
  let(:valid) { true }

  context 'when api returns correct response' do
    before do
      allow(CompanyNameForm)
        .to receive(:new)
        .and_return(instance_double(CompanyNameForm, valid?: valid))
      response = read_response('create_account.json')
      allow(AccountsApi).to receive(:create_account).and_return(response)
    end

    it 'returns the String class' do
      expect(service.class).to eq(String)
    end

    it 'calls CompanyNameForm with proper params' do
      expect(CompanyNameForm).to receive(:new).with(company_name: company_name)
      service
    end

    it 'calls AccountsApi.create_account with proper params' do
      expect(AccountsApi)
        .to receive(:create_account)
        .with(company_name: company_name)
      service
    end
  end

  context 'when api returns 422 status' do
    let(:error_code) { 'duplicate' }

    before do
      allow(CompanyNameForm)
        .to receive(:new)
        .and_return(instance_double(CompanyNameForm, valid?: valid))

      stub_request(:post, /accounts/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "errorCode": error_code
        }.to_json
      )
    end

    context 'when company name is not unique' do
      it 'raises `InvalidCompanyNameException` exception with proper errors object' do
        expect { service }.to raise_error(
          InvalidCompanyNameException, I18n.t('company_name.errors.duplicate')
        )
      end
    end

    context 'when company name has abusive term' do
      let(:error_code) { 'abuse' }

      it 'raises `InvalidCompanyNameException` exception with proper errors object' do
        expect { service }.to raise_error(
          InvalidCompanyNameException, I18n.t('company_name.errors.abuse')
        )
      end
    end
  end
end
