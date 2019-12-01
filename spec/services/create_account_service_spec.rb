# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAccountService do
  subject(:service_call) do
    described_class.call(
      organisations_params: organisations_params,
      company_name: company_name
    )
  end

  let(:organisations_params) do
    {
      email: email,
      email_confirmation: email,
      password: '8NAOTpMkx2%9',
      password_confirmation: '8NAOTpMkx2%9'
    }
  end

  let(:email) { 'example@email.com' }
  let(:company_name) { 'Company name' }

  describe '#call' do
    context 'with valid params' do
      it 'returns nil' do
        expect(service_call).to be nil
      end
    end

    context 'with invalid params' do
      let(:email) { '' }

      it 'raises exception' do
        expect { service_call }.to raise_exception(NewPasswordException)
      end
    end
  end
end
