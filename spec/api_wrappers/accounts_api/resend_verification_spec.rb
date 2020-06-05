# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi.create_account' do
  subject(:call) do
    AccountsApi.resend_verification(
      account_id: account_id,
      user_id: user_id,
      verification_url: verification_url
    )
  end

  let(:account_id) { '4d9ed7eb-14b3-4452-93d9-53ac180322ff' }
  let(:user_id) { '798f07f1-92a7-47d4-b456-60d149369c7b' }
  let(:verification_url) { 'http://example.url' }
  let(:base_url) { "/accounts/#{account_id}/users/#{user_id}/verifications" }

  context 'when the response status is 200' do
    before { stub_request(:post, /#{base_url}/).to_return(status: 200) }

    it 'returns proper fields' do
      expect(call).to be_truthy
    end

    it 'calls API with proper body' do
      body = { verificationUrl: verification_url }
      call
      expect(WebMock).to have_requested(:post, /#{base_url}/).with(body: body).once
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, /#{base_url}/).to_return(
        status: 404,
        body: { 'message' => 'Account id not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { call }.to raise_exception(BaseApi::Error404Exception)
    end
  end
end
