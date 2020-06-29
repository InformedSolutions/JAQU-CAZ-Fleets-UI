# frozen_string_literal: true

require 'rails_helper'

describe ManageUsers::User, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      'accountUserId' => account_id,
      'name' => name,
      'email' => email
    }
  end

  let(:account_id) { SecureRandom.uuid }
  let(:name) { 'John Doe' }
  let(:email) { 'test@example.com' }

  describe '.account_id' do
    it 'returns account_id' do
      expect(subject.account_id).to eq(account_id)
    end
  end

  describe '.name' do
    it 'returns name' do
      expect(subject.name).to eq(name)
    end
  end

  describe '.email' do
    it 'returns email' do
      expect(subject.email).to eq(email)
    end
  end
end
