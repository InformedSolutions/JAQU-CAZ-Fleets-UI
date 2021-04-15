# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsHistory::PaymentHistoryController - GET #initiate_payment_history_download', type: :request do
  subject { get initiate_payment_history_download_path }

  context 'when make_payments permissions' do
    before do
      allow(PaymentHistory::InitiatePaymentHistoryExport).to receive(:call).and_return({})
      sign_in user
      subject
    end

    let(:user) { make_payments_user }

    it 'calls PaymentHistory::InitiatePaymentHistoryExport with users filtering' do
      expect(PaymentHistory::InitiatePaymentHistoryExport).to have_received(:call)
        .with(user: user, filtered_export: true)
    end

    it 'redirects to payment_history_downloading_path' do
      expect(subject).to redirect_to payment_history_downloading_path
    end
  end

  context 'when view_payments persmissions' do
    before do
      allow(PaymentHistory::InitiatePaymentHistoryExport).to receive(:call).and_return({})
      sign_in user
      subject
    end

    let(:user) { view_payment_history_user }

    it 'calls PaymentHistory::InitiatePaymentHistoryExport with users filtering' do
      expect(PaymentHistory::InitiatePaymentHistoryExport).to have_received(:call)
        .with(user: user, filtered_export: false)
    end

    it 'redirects to payment_history_downloading_path' do
      expect(subject).to redirect_to payment_history_downloading_path
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
