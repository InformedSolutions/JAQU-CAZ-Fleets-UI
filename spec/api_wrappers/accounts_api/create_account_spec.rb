# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccountsApi.create_account' do
  subject(:call) do
    AccountsApi.create_account(email: email, password: password, company_name: name)
  end

  let(:email) { 'test@example.com' }
  let(:password) { 'password' }
  let(:name) { 'Awesome Inc.' }

  context 'when the response status is 201' do
    before do
      user_details = read_unparsed_response('user.json')
      stub_request(:post, /accounts/).to_return(
        status: 201,
        body: user_details
      )
    end

    it 'returns proper fields' do
      expect(call.keys).to contain_exactly(
        'accountId', 'accountName', 'accountUserId', 'admin', 'email'
      )
    end

    it 'calls API with proper body' do
      body = { email: email, password: password, accountName: name }
      call
      expect(WebMock).to have_requested(:post, /accounts/).with(body: body).once
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:post, /accounts/).to_return(
        status: 422,
        body: {
          'message' => 'Creation failed',
          'details' => %w[emailNotUnique passwordNotValid]
        }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { call }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
