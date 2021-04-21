# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentHistoryApi.payment_history_export' do
  subject do
    PaymentHistoryApi.payment_history_export(account_id: account_id, recipient_id: recipient_id,
                                             filtered_user_id: filtered_user_id)
  end

  let(:account_id) { SecureRandom.uuid }
  let(:recipient_id) { SecureRandom.uuid }
  let(:filtered_user_id) { SecureRandom.uuid }
  let(:url) { /payment-history-export/ }

  context 'when the response status is 200' do
    before do
      stub_request(:post, /#{url}/).to_return(status: 200, body: {}.to_json)
    end

    context 'when filtered_user_id is missing' do
      let(:filtered_user_id) { nil }

      it 'does not include filtered_user_id in params' do
        body = { recipientAccountUserId: recipient_id }
        subject
        expect(WebMock).to have_requested(:post, /#{url}/).with(body: body)
      end
    end

    context 'when filtered_user_id is present' do
      it 'includes filtered_user_id in params' do
        body = { recipientAccountUserId: recipient_id, filteredPaymentsForAccountsUserId: filtered_user_id }
        subject
        expect(WebMock).to have_requested(:post, /#{url}/).with(body: body)
      end
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, /#{url}/).to_return(status: 404, body: { message: 'Account id not found' }.to_json)
    end

    it 'raises Error404Exception' do
      expect { subject }.to raise_exception(BaseApi::Error404Exception)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:post, /#{url}/).to_return(
        status: 500,
        body: { message: 'Something went wrong' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { subject }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
