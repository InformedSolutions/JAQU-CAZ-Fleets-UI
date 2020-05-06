# frozen_string_literal: true

require 'rails_helper'

describe CheckCompanyName do
  subject(:service) do
    described_class.call(company_name: company_name)
  end

  let(:company_name) { 'Mikusek Software' }
  let(:valid) { true }
  let(:errors) { [] }

  context 'when valid params' do
    before do
      allow(CompanyNameForm)
        .to receive(:new)
        .and_return(instance_double(CompanyNameForm, valid?: valid))
    end

    it 'calls CompanyNameForm with proper params' do
      expect(CompanyNameForm).to receive(:new).with(company_name: company_name)
      service
    end
  end

  context 'when invalid params' do
    let(:valid) { false }
    let(:errors) { ActiveModel::Errors.new(['Some error']) }

    before do
      allow(CompanyNameForm)
        .to receive(:new)
        .and_return(instance_double(CompanyNameForm, valid?: valid, errors: errors))
    end

    context 'when company_name is invalid' do
      it 'raises `InvalidCompanyNameException` exception with proper errors object' do
        expect { service }.to raise_error(
          InvalidCompanyNameException
        )
      end
    end
  end
end
