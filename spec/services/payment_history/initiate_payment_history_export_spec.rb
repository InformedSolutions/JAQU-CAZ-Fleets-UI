# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentHistory::InitiatePaymentHistoryExport do
  subject { described_class.call(user: user, filtered_export: filtered_export) }

  let(:user) { create_user }

  before do
    allow(PaymentHistoryApi).to receive(:payment_history_export)
    subject
  end

  context 'when filtered_export = true' do
    let(:filtered_export) { true }

    it 'calls initiate_export_for_filtered_users' do
      expect(PaymentHistoryApi).to have_received(:payment_history_export)
        .with(account_id: user.account_id, recipient_id: user.user_id,
              filtered_user_id: user.user_id)
    end
  end

  context 'when filtered_export = false' do
    let(:filtered_export) { false }

    it 'calls initiate_export_for_all_users' do
      expect(PaymentHistoryApi).to have_received(:payment_history_export)
        .with(account_id: user.account_id, recipient_id: user.user_id)
    end
  end
end
