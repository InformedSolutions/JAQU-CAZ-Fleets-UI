# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetPasswordForm, type: :model do
  subject(:form) { described_class.new(email_address: email_address) }

  let(:email_address) { 'user@example.com' }

  %w[user@example.com user.user@example.com].each do |value|
    let(:email_address) { value }

    it 'is valid with a proper email' do
      expect(form).to be_valid
    end
  end

  context 'when email_address is empty' do
    let(:email_address) { '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:email_address]).to include(
        I18n.t('reset_password_form.email_missing')
      )
    end
  end

  context 'when invalid email format' do
    %w[
      user.example.com test@informed..com test.@informed.com test@@informed.com test@info@rmed.com
    ].each do |value|
      let(:email_address) { value }

      it 'is not valid' do
        expect(form).not_to be_valid
      end

      it 'has a proper error message' do
        form.valid?
        expect(form.errors.messages[:email_address]).to include(
          I18n.t('reset_password_form.email_invalid_format')
        )
      end
    end
  end

  context 'when email is too long' do
    let(:email_address) { "#{SecureRandom.alphanumeric(36)}@email.com" }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:email_address]).to include(
        I18n.t(
          'input_form.errors.maximum_length',
          attribute: 'Email address'
        )
      )
    end
  end
end
