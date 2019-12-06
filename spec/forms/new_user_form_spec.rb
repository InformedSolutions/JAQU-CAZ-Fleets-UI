# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewUserForm, type: :model do
  subject(:form) { described_class.new(user_params) }

  let(:user_params) do
    {
      name: name,
      email_address: email_address
    }
  end

  let(:name) { 'User Name' }
  let(:email_address) { 'example@email.com' }

  it { is_expected.to be_valid }

  context 'when email is in an invalid format' do
    let(:email_address) { 'example_email.com' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:email_address].join(',')).to include(
        I18n.t('input_form.errors.invalid_format', attribute: 'Email address')
      )
    end
  end

  context 'when email_address is too long' do
    let(:email_address) { 'example_email.com' * 3 }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:email_address].join(',')).to include(
        I18n.t('input_form.errors.maximum_length', attribute: 'Email address')
      )
    end
  end

  context 'name field' do
    context 'when name is empty' do
      let(:name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        form.valid?
        expect(form.errors.messages[:name].join(',')).to include(
          I18n.t('input_form.errors.missing', attribute: 'Name')
        )
      end
    end

    context 'when name is too long' do
      let(:name) { 'User Name' * 7 }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        form.valid?
        expect(form.errors.messages[:name].join(',')).to include(
          I18n.t('input_form.errors.maximum_length', attribute: 'Name')
        )
      end
    end
  end
end
