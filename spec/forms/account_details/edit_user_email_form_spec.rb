# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::EditUserEmailForm, type: :model do
  subject { described_class.new(email: email) }

  context 'when email is valid' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    let(:email) { 'valid@email.com' }

    it { is_expected.to be_valid }
  end

  context 'when email is not present' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    let(:email) { '' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.email_missing'))
      )
    end
  end

  context 'when email is invalid format' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    let(:email) { 'invalid-format' }

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.email_invalid_format'))
      )
    end
  end

  context 'when email is duplicated' do
    before do
      allow(AccountsApi::Accounts)
        .to receive(:user_validations)
        .and_raise(BaseApi::Error400Exception.new(400, '', ''))
    end

    let(:email) { 'valid@email.com' }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.email_duplicated'))
      )
    end
  end
end
