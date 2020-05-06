# frozen_string_literal: true

require 'rails_helper'

describe CreateAccountForm, type: :model do
  subject(:form) do
    described_class.new(
      company_name: company_name,
      confirm_fleet_check: confirm_fleet_check
    )
  end

  let(:company_name) { 'Company name' }
  let(:confirm_fleet_check) { 'less_than_two' }

  it { is_expected.to be_valid }

  context 'when confirm_fleet_check is empty' do
    let(:confirm_fleet_check) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:confirm_fleet_check]).to include(I18n.t('form.errors.missing'))
    end
  end

  context 'when company_name is empty' do
    let(:company_name) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:company_name]).to include(I18n.t('form.errors.missing'))
    end
  end

  context 'when company_name is too long' do
    let(:company_name) { '12345' * 37 }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:company_name]).to include(
        I18n.t('form.errors.maximum_length', length: 180)
      )
    end
  end

  context 'when company name has valid format' do
    [
      'name with space',
      'UPPER CASES with 12 numbers',
      'Ampersand & forward slash /',
      "name with apostrophe ' && full stop...",
      'ěą śpórt cīnī gęń'
    ].each do |valid_name|
      let(:company_name) { valid_name }

      it { is_expected.to be_valid }
    end
  end

  context 'when company name has invalid format' do
    [
      '(Parentheses not allowed)',
      'also some other chars *',
      '#stayathome',
      "(>'')> <(''<)"
    ].each do |invalid_name|
      let(:company_name) { invalid_name }

      it { is_expected.not_to be_valid }

      it 'has proper error message' do
        form.valid?
        expect(form.errors.messages[:company_name]).to include(
          I18n.t('form.errors.invalid_format')
        )
      end
    end
  end
end
