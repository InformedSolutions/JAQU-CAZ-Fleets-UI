# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::AddUserForm, type: :model do
  subject { described_class.new(account_id: account_id, new_user: new_user_data.stringify_keys) }

  let(:account_id) { create_user.account_id }
  let(:new_user_data) { { name: name, email: email } }
  let(:name) { 'New User Name' }
  let(:email) { 'new_user@example.com' }

  describe 'valid?' do
    before { allow(AccountsApi).to receive(:user_validations).and_return(true) }

    it { is_expected.to be_valid }

    context 'when name is empty' do
      let(:name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        subject.valid?
        expect(subject.errors.messages[:name].join(',')).to include("Enter the user's name")
      end
    end

    context 'when email is empty' do
      let(:email) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        subject.valid?
        expect(subject.errors.messages[:email].join(',')).to include("Enter the user's email address")
      end
    end

    context 'when email in invalid format' do
      let(:email) { 'test,,,@test.com ' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        subject.valid?
        expect(subject.errors.messages[:email].join(',')).to include(
          'Enter the user’s email address in a valid format'
        )
      end
    end
  end

  describe '.email_not_duplicated' do
    before do
      allow(AccountsApi).to receive(:user_invitations).and_return(true)
      allow(AccountsApi).to receive(:user_validations).and_raise(
        BaseApi::Error400Exception.new(400, '', '')
      )
    end

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      subject.valid?
      expect(subject.errors[:email]).to include('Email address already exists')
    end
  end
end
