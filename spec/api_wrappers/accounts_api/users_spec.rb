# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi.users' do
  subject { AccountsApi.users(account_id: account_id) }

  let(:account_id) { '3fa85f64-5717-4562-b3fc-2c963f66afa6' }
  let(:base_url) { "accounts/#{account_id}/users" }

  context 'when the response status is 200' do
    before do
      user_details = read_unparsed_response('/manage_users/users.json')
      stub_request(:get, /#{base_url}/).to_return(status: 200, body: user_details)
    end

    it 'calls API with proper query data' do
      subject
      expect(WebMock).to have_requested(:get, %r{accounts/#{account_id}/users})
    end

    it 'returns proper fields' do
      expect(subject.first.keys).to contain_exactly('accountUserId', 'name', 'email')
    end

    context 'when the response status is 404' do
      before do
        stub_request(:get, /#{base_url}/).to_return(
          status: 404,
          body: { 'message' => 'Account id not found' }.to_json
        )
      end

      it 'raises Error404Exception' do
        expect { subject }.to raise_exception(BaseApi::Error404Exception)
      end
    end

    context 'when the response status is 500' do
      before do
        stub_request(:get, /#{base_url}/).to_return(
          status: 500,
          body: { 'message' => 'Something went wrong' }.to_json
        )
      end

      it 'raises Error500Exception' do
        expect { subject }.to raise_exception(BaseApi::Error500Exception)
      end
    end
  end
end
