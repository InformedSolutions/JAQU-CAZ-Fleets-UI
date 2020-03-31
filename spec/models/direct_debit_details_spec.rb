# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectDebitDetails, type: :model do
  subject { described_class.new(data) }

  let(:data) do
    {
      'userEmail' => email,
      'referenceNumber' => payment_reference,
      'externalPaymentId' => external_id
    }
  end

  let(:email) { 'test@example.com' }
  let(:payment_reference) { 'WYP3HNDP' }
  let(:external_id) { SecureRandom.uuid }

  describe '.user_email' do
    it 'returns the email' do
      expect(subject.user_email).to eq(email)
    end
  end

  describe '.payment_reference' do
    it 'returns payment reference' do
      expect(subject.payment_reference).to eq(payment_reference)
    end
  end

  describe '.external_id' do
    it 'returns external id' do
      expect(subject.external_id).to eq(external_id)
    end
  end
end
