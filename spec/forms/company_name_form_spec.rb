# frozen_string_literal: true

require 'rails_helper'

describe CompanyNameForm, type: :model do
  subject(:form) { described_class.new(company_name_params) }

  let(:company_name_params) { { company_name: company_name } }
  let(:company_name) { 'Company name' }

  it { is_expected.to be_valid }

  context 'when company_name is empty' do
    let(:company_name) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:company_name]).to include(I18n.t('form.errors.missing'))
    end
  end

  context 'when company_name is too long' do
    let(:company_name) { '12345' * 21 }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:company_name]).to include(
        I18n.t('form.errors.maximum_length', length: 100)
      )
    end
  end
end
