# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #handle_payment_history_download_attempt', type: :request do
  subject { get payment_history_export_path('exportId' => export_id) }

  let(:export_id) { SecureRandom.uuid }
  let(:user) { make_payments_user }
  let(:file_url) { 'http://example.com' }

  before do
    allow(PaymentHistory::ExportStatus).to receive(:new)
      .and_return(export_status_stub)
    sign_in user
  end

  context 'when fileUrl is active for the current user' do
    let(:export_status_stub) do
      instance_double('PaymentHistory::ExportStatus', link_active_for?: true, file_url: file_url)
    end

    it 'redirects user to download page' do
      expect(subject).to redirect_to(payment_history_download_path)
    end

    it 'sets :payment_history_file_url in session' do
      subject
      expect(session[:payment_history_file_url]).to eq(file_url)
    end
  end

  context 'when fileUrl not active for the current user' do
    let(:export_status_stub) do
      instance_double('PaymentHistory::ExportStatus', link_active_for?: false)
    end

    it 'redirects user to link expired page' do
      expect(subject).to redirect_to(payment_history_link_expired_path)
    end

    it 'does not set :payment_history_file_url key in session' do
      subject
      expect(session[:payment_history_file_url]).to eq(nil)
    end
  end
end
