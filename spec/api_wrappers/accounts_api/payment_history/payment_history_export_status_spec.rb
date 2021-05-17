# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi::PaymentHistory.payment_history_export_status' do
  subject do
    AccountsApi::PaymentHistory
      .payment_history_export_status(account_id: account_id, job_id: job_id)
  end

  let(:account_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }
  let(:url) { /payment-history-export/ }

  context 'when the response status is 200' do
    before do
      response = read_unparsed_response('/payment_history/export_status.json')
      stub_request(:get, /#{url}/).to_return(status: 200, body: response)
    end

    it 'returns proper fields' do
      expect(subject.keys).to contain_exactly('recipientAccountUserId', 'fileUrl', 'status')
    end

    it 'calls API with proper data' do
      subject
      expect(WebMock).to have_requested(:get, %r{accounts/#{account_id}/payment-history-export/#{job_id}})
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 404,
        body: { message: 'Account not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:get, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
