# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistory::PaymentHistoryController - GET #handle_payment_history_download_link', type: :request do
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
      instance_double('PaymentHistory::ExportStatus',
                      link_active?: true, link_accessible_for?: true, file_url: file_url)
    end

    before { subject }

    it 'redirects user to download page' do
      expect(response).to redirect_to(payment_history_download_path)
    end

    it 'sets :payment_history_file_url in session' do
      expect(session[:payment_history_file_url]).to(
        eq(payment_history_export_download_path(exportId: export_id))
      )
    end

    it 'sets :payment_history_file_name in session' do
      expect(session[:payment_history_file_name]).to eq(file_url)
    end
  end

  context 'when fileUrl active but not accessible for the current user' do
    let(:export_status_stub) do
      instance_double('PaymentHistory::ExportStatus',
                      link_active?: true, link_accessible_for?: false)
    end

    before { subject }

    it 'redirects user to link expired page' do
      expect(response).to redirect_to(payment_history_link_no_access_path)
    end

    it 'does not set :payment_history_file_url key in session' do
      expect(session[:payment_history_file_url]).to eq(nil)
    end
  end

  context 'when fileUrl not active' do
    let(:export_status_stub) do
      instance_double('PaymentHistory::ExportStatus',
                      link_active?: false, link_accessible_for?: true)
    end

    before { subject }

    it 'redirects user to link expired page' do
      expect(response).to redirect_to(payment_history_link_expired_path)
    end

    it 'does not set :payment_history_file_url key in session' do
      expect(session[:payment_history_file_url]).to eq(nil)
    end
  end
end
