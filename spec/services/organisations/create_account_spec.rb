# frozen_string_literal: true

require 'rails_helper'

describe Organisations::CreateAccount do
  subject { described_class.call(company_name: company_name) }

  let(:company_name) { 'Mikusek Software' }
  let(:valid) { true }
  let(:errors) { [] }

  context 'when api returns correct response' do
    before do
      allow(Organisations::CompanyNameForm)
        .to receive(:new)
        .and_return(instance_double(Organisations::CompanyNameForm, valid?: valid))
      response = read_response('create_account.json')
      allow(AccountsApi).to receive(:create_account).and_return(response)
    end

    it 'returns the String class' do
      expect(subject.class).to eq(String)
    end

    it 'calls Organisations::CompanyNameForm with proper params' do
      expect(Organisations::CompanyNameForm).to receive(:new).with(company_name: company_name)
      subject
    end

    it 'calls AccountsApi.create_account with proper params' do
      expect(AccountsApi)
        .to receive(:create_account)
        .with(company_name: company_name)
      subject
    end
  end

  context 'when api throws exception' do
    let(:company_name_form_instance) do
      instance_double(Organisations::CompanyNameForm,
                      valid?: valid,
                      errors: errors,
                      first_error_message: 'test')
    end

    before { allow(Organisations::CompanyNameForm).to receive(:new).and_return(company_name_form_instance) }

    context 'when params are not valid' do
      let(:valid) { false }
      let(:errors) { ActiveModel::Errors.new(['Some error']) }

      it 'raises `InvalidCompanyNameException` exception' do
        expect { subject }.to raise_error(
          InvalidCompanyNameException
        )
      end
    end
  end

  context 'when api returns 422 status' do
    let(:error_code) { 'duplicate' }

    before do
      allow(Organisations::CompanyNameForm).to receive(:new).and_return(
        instance_double(Organisations::CompanyNameForm, valid?: valid)
      )

      stub_request(:post, /accounts/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "errorCode": error_code
        }.to_json
      )
    end

    context 'when company name is not unique' do
      it 'raises `UnableToCreateAccountException` exception' do
        expect { subject }.to raise_error(
          UnableToCreateAccountException, I18n.t('company_name.errors.duplicate')
        )
      end
    end

    context 'when company name has abusive term' do
      let(:error_code) { 'abuse' }

      it 'raises `UnableToCreateAccountException` exception' do
        expect { subject }.to raise_error(
          UnableToCreateAccountException, I18n.t('company_name.errors.abuse')
        )
      end
    end
  end
end
