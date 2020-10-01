# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::EditCompanyNameForm, type: :model do
  subject { described_class.new(company_name_params) }

  let(:company_name_params) { { account_id: @uuid, company_name: company_name } }
  let(:company_name) { 'Company name' }

  it { is_expected.to be_valid }

  context '.submit' do
    before do
      allow(AccountsApi).to receive(:update_company_name).and_return(true)
      subject.submit
    end

    it 'calls AccountsApi with correct parameters' do
      body = { accountName: 'Company name' }
      allow(AccountsApi).to receive(:update_company_name).with(body: body).and_return(true)
    end
  end

  context 'when provided company name already exists' do
    before do
      allow(AccountsApi).to receive(:update_company_name).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'duplicate')
      )
      subject.submit
    end

    it 'assigns a proper error message' do
      expect(subject.errors[:company_name])
        .to include(I18n.t('company_name.errors.duplicate'))
    end

    it '.submit returns false' do
      expect(subject.submit).to eq(false)
    end
  end

  context 'when provided company name contains a profanity' do
    before do
      allow(AccountsApi).to receive(:update_company_name).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'profanity')
      )
      subject.submit
    end

    it 'assigns a proper error message' do
      expect(subject.errors[:company_name])
        .to include(I18n.t('company_name.errors.profanity'))
    end

    it '.submit returns false' do
      expect(subject.submit).to eq(false)
    end
  end

  context 'when provided company name contains an abusive term' do
    before do
      allow(AccountsApi).to receive(:update_company_name).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'abuse')
      )
      subject.submit
    end

    it 'assigns a proper error message' do
      expect(subject.errors[:company_name])
        .to include(I18n.t('company_name.errors.abuse'))
    end

    it '.submit returns false' do
      expect(subject.submit).to eq(false)
    end
  end

  context 'when api returns unknown errorCode' do
    before do
      allow(AccountsApi).to receive(:update_company_name).and_raise(
        BaseApi::Error422Exception.new(422, '', 'errorCode' => 'code')
      )
      subject.submit
    end

    it 'assigns a proper error message' do
      expect(subject.errors[:company_name])
        .to include('Something went wrong')
    end

    it '.submit returns false' do
      expect(subject.submit).to eq(false)
    end
  end
end
