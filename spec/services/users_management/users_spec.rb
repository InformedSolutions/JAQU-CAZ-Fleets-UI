# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::Users do
  subject { described_class.call(account_id: @uuid) }

  describe '#call' do
    before { mock_users }

    it 'returns only nine users' do
      expect(subject.count).to eq(9)
    end

    it 'returns sorted users by name' do
      expect(subject.first.name).to eq('Anisah Melendez')
      expect(subject.last.name).to eq('Reef Giles')
    end

    it 'returns UsersManagement::User instance' do
      expect(subject.first).to be_a(UsersManagement::User)
    end

    it 'calls AccountsApi with proper params' do
      expect(AccountsApi).to receive(:users).with(account_id: @uuid)
      subject
    end
  end

  describe '#filtered' do
    subject { described_class.new(account_id: @uuid).filtered }

    before { mock_users }

    it 'returns only nine users' do
      expect(subject.count).to eq(9)
    end

    it 'returns not sorted users by name' do
      expect(subject.first['name']).to eq('John Doe')
      expect(subject.last['name']).to eq('Giles Kelsea')
    end

    it 'returns Array instance' do
      expect(subject).to be_a(Array)
    end

    it 'calls AccountsApi with proper params' do
      expect(AccountsApi).to receive(:users).with(account_id: @uuid)
      subject
    end
  end
end
