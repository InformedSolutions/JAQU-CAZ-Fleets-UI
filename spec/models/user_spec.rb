# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create_user(account_id: account_id) }

  let(:account_id) { SecureRandom.uuid }

  describe '.fleet' do
    it 'returns a fleet object' do
      expect(user.fleet).to be_a(Fleet)
    end

    it 'calls Fleet.new with proper params' do
      expect(Fleet).to receive(:new).with(account_id)
      user.fleet
    end
  end

  it { is_expected.to delegate_method(:vehicles).to(:fleet) }
  it { is_expected.to delegate_method(:add_vehicle).to(:fleet) }
end
