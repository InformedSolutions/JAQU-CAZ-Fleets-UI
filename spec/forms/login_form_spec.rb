# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginForm, type: :model do
  subject(:form) { described_class.new(email, password) }

  let(:email) { 'test@example.com' }
  let(:password) { 'password' }

  it { is_expected.to be_valid }

  context 'when email is empty' do
    let(:email) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:email]).to include(I18n.t('login_form.email_missing'))
    end
  end

  context 'when email is invalid' do
    let(:email) { 'test' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:email]).to include(I18n.t('login_form.invalid_email'))
    end
  end

  context 'when password is empty' do
    let(:password) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      form.valid?
      expect(form.errors.messages[:password]).to include(I18n.t('login_form.password_missing'))
    end
  end
end
