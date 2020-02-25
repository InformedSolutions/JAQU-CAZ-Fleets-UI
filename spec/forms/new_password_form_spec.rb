# frozen_string_literal: true

require 'rails_helper'

describe NewPasswordForm, type: :model do
  subject(:form) do
    described_class.new(password: password, password_confirmation: confirmation)
  end

  let(:password) { 'password' }
  let(:confirmation) { password }

  before { form.valid? }

  it 'is valid with a proper password' do
    expect(form).to be_valid
  end

  context 'when password is empty' do
    let(:password) { '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper password message' do
      expect(form.errors[:password])
        .to include(I18n.t('password.errors.password_required'))
    end
  end

  context 'when password confirmation is empty' do
    let(:confirmation) { '' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper password confirmation message' do
      expect(form.errors[:password_confirmation])
        .to include(I18n.t('password.errors.confirmation_required'))
    end
  end

  context 'when password confirmation is different' do
    let(:confirmation) { 'other_password' }

    it 'is not valid' do
      expect(form).not_to be_valid
    end

    it 'has a proper password message' do
      expect(form.errors[:password])
        .to include(I18n.t('password.errors.password_equality'))
    end

    it 'has a proper password confirmation message' do
      expect(form.errors[:password_confirmation])
        .to include(I18n.t('password.errors.password_equality'))
    end
  end
end
