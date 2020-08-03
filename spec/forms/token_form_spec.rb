# frozen_string_literal: true

require 'rails_helper'

describe TokenForm, type: :model do
  subject { described_class.new(token: token) }

  let(:token) { @uuid }

  before do
    allow(AccountsApi).to receive(:validate_password_reset).and_return(true)
  end

  context 'when token is missing' do
    let(:token) { nil }

    it 'is invalid' do
      expect(subject).not_to be_valid
    end

    it 'assigns error' do
      subject.valid?
      expect(subject.errors[:token]).to include(I18n.t('token_form.token_missing'))
    end

    it 'does not call API' do
      expect(AccountsApi).not_to receive(:validate_password_reset)
      subject.valid?
    end
  end

  context 'with a valid token' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'calls API' do
      expect(AccountsApi).to receive(:validate_password_reset).with(token: token)
      subject.valid?
    end
  end

  context 'with invalid token' do
    before do
      allow(AccountsApi).to receive(:validate_password_reset).and_raise(
        BaseApi::Error400Exception.new(400, '', {})
      )
    end

    it 'is invalid' do
      expect(subject).not_to be_valid
    end

    it 'assigns error' do
      subject.valid?
      expect(subject.errors[:token]).to include(I18n.t('token_form.token_invalid'))
    end
  end
end
