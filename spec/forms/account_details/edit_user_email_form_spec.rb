# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::EditUserEmailForm, type: :model do
  subject { described_class.new(email_params) }

  let(:email) { '' }
  let(:confirmation) { '' }
  let(:email_params) do
    {
      email: email,
      confirmation: confirmation,
      account_id: SecureRandom.uuid,
      current_email: 'current@email.com'
    }
  end

  context 'when params are valid' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    let(:email) { 'valid@email.com' }
    let(:confirmation) { 'valid@email.com' }

    it { is_expected.to be_valid }
  end

  context 'when only email is not present' do
    let(:email) { '' }
    let(:confirmation) { 'valid@email.com' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper email error message' do
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.email_missing'))
      )
    end

    it 'has a proper confirmation error message' do
      expect(subject.errors.messages[:confirmation]).to(
        include(I18n.t('edit_user_email_form.errors.emails_not_equal'))
      )
    end
  end

  context 'when only confirmation is not present' do
    let(:email) { 'valid@email.com' }
    let(:confirmation) { '' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper confirmation error message' do
      expect(subject.errors.messages[:confirmation]).to(
        include(I18n.t('edit_user_email_form.errors.email_missing'))
      )
    end

    it 'has a proper email error message' do
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.emails_not_equal'))
      )
    end
  end

  context 'when emails do not match' do
    let(:email) { 'valid@email.com' }
    let(:confirmation) { 'valid@email.pl' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper email error message' do
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.emails_not_equal'))
      )
    end

    it 'has a proper confirmation error message' do
      expect(subject.errors.messages[:confirmation]).to(
        include(I18n.t('edit_user_email_form.errors.emails_not_equal'))
      )
    end
  end

  context 'when only email has invalid format' do
    let(:email) { 'valid@email.com' }
    let(:confirmation) { 'invalid-format' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper email error message' do
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.emails_not_equal'))
      )
    end

    it 'has a proper confirmation error message' do
      expect(subject.errors.messages[:confirmation]).to(
        include(I18n.t('edit_user_email_form.errors.email_invalid_format'))
      )
    end
  end

  context 'when emails match but have invalid format' do
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }

    let(:email) { 'invalid-format' }
    let(:confirmation) { 'invalid-format' }

    before { subject.valid? }

    it { is_expected.not_to be_valid }

    it 'has a proper email error message' do
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.email_invalid_format'))
      )
    end

    it 'has a proper confirmation error message' do
      expect(subject.errors.messages[:confirmation]).to(
        include(I18n.t('edit_user_email_form.errors.email_invalid_format'))
      )
    end
  end

  context 'when email is duplicated' do
    before do
      allow(AccountsApi::Accounts)
        .to receive(:user_validations)
        .and_raise(BaseApi::Error400Exception.new(400, '', ''))
      subject.valid?
    end

    let(:email) { 'current@email.com' }
    let(:confirmation) { 'current@email.com' }

    it '.current_email_reuse? returns correct value' do
      expect(subject.current_email_reuse?).to eq(true)
    end

    it 'has a proper email error message' do
      expect(subject.errors.messages[:email]).to(
        include(I18n.t('edit_user_email_form.errors.email_duplicated'))
      )
    end

    it 'has no confirmation error message' do
      expect(subject.errors.messages[:confirmation]).to eq([])
    end
  end
end
