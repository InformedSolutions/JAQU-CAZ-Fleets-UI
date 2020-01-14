# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi.verify_user' do
  subject(:call) { AccountsApi.verify_user(account_id: account_id, user_id: user_id) }

  let(:account_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:url) { %r{/accounts/#{account_id}/users/#{user_id}/verify} }

  context 'when the response status is 200' do
    before do
      stub_request(:post, url).to_return(status: 200, body: '{}')
    end

    it 'calls API with no body' do
      call
      expect(WebMock).to have_requested(:post, url).with(body: nil).once
    end
  end

  context 'when the response status is 400' do
    before do
      stub_request(:post, url).to_return(
        status: 400,
        body: { 'message' => 'Email already confirmed' }.to_json
      )
    end

    it 'raises Error400Exception' do
      expect { call }.to raise_exception(BaseApi::Error400Exception)
    end
  end

  context 'when the response status is 404' do
    before do
      stub_request(:post, url).to_return(
        status: 404,
        body: { 'message' => 'User not found' }.to_json
      )
    end

    it 'raises Error404Exception' do
      expect { call }.to raise_exception(BaseApi::Error404Exception)
    end
  end
end
