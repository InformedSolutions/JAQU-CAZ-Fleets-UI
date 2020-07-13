# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::User, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      'accountUserId' => user_id,
      'name' => name,
      'email' => email
    }
  end

  let(:user_id) { SecureRandom.uuid }
  let(:name) { 'John Doe' }
  let(:email) { 'test@example.com' }

  describe '.user_id' do
    it 'returns user_id' do
      expect(subject.user_id).to eq(user_id)
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
