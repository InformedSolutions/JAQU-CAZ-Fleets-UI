# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::EditUserEmailForm, type: :model do
  subject { described_class.new(email: email) }

  context 'when email is valid' do
<<<<<<< HEAD
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }
=======
    before { allow(AccountsApi).to receive(:user_validations).and_return(true) }
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)

    let(:email) { 'valid@email.com' }

    it { is_expected.to be_valid }
  end

  context 'when email is not present' do
<<<<<<< HEAD
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }
=======
    before { allow(AccountsApi).to receive(:user_validations).and_return(true) }
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)

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
<<<<<<< HEAD
    before { allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true) }
=======
    before { allow(AccountsApi).to receive(:user_validations).and_return(true) }
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)

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
<<<<<<< HEAD
      allow(AccountsApi::Accounts)
=======
      allow(AccountsApi)
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
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
