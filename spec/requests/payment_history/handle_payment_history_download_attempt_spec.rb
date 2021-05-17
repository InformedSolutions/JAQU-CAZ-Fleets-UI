# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsHistory::PaymentHistoryController - GET #handle_payment_history_download_attempt', type: :request do
  subject { get payment_history_export_download_path('exportId' => export_id) }

  let(:export_id) { SecureRandom.uuid }
  let(:user) { make_payments_user }
  let(:file_url) { 'http://example.com' }
  let(:file_body) { instance_double('StringIO', read: 'test') }

  before do
    allow(PaymentHistory::ExportStatus).to receive(:new)
      .and_return(export_status_stub)
    sign_in user
  end

  context 'when fileUrl is active for the current user' do
    let(:export_status_stub) do
      instance_double('PaymentHistory::ExportStatus',
                      link_active?: true, link_accessible_for?: true, file_url: file_url,
                      file_body: file_body, file_content_type: 'text/csv')
    end

    before { subject }

    it 'send csv file' do
      expect(response.header['Content-Type']).to eql('text/csv')
    end
  end

  context 'when fileUrl active or not accessible for the current user' do
    let(:export_status_stub) do
      instance_double('PaymentHistory::ExportStatus',
                      link_active?: true, link_accessible_for?: false)
    end

    before { subject }

    it 'redirects user to link expired page' do
      expect(response).to redirect_to(payment_history_download_path)
    end
  end
end
