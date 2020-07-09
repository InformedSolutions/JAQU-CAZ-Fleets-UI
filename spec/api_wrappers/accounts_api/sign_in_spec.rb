# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi.sign_in' do
  subject(:call) { AccountsApi.sign_in(email: email, password: password) }

  let(:email) { 'test@example.com' }
  let(:password) { 'password' }

  context 'when the response status is 200' do
    before do
      user_details = read_unparsed_response('create_user.json')
      stub_request(:post, %r{auth/login}).to_return(
        status: 200,
        body: user_details
      )
    end

    it 'returns proper fields' do
      expect(call.keys).to contain_exactly(
        'accountId', 'accountName', 'accountUserId', 'owner', 'permissions', 'email'
      )
    end

    it 'calls API with proper body' do
      body = { email: email, password: password }
      call
      expect(WebMock).to have_requested(:post, %r{auth/login}).with(body: body).once
    end

    context 'when email has uppercased signs' do
      let(:email) { 'TEST@example.com' }

      it 'calls API with proper body' do
        body = { email: email.downcase, password: password }
        call
        expect(WebMock).to have_requested(:post, %r{auth/login}).with(body: body).once
      end
    end
  end

  context 'when the response status is 401' do
    before do
      stub_request(:post, %r{auth/login}).to_return(
        status: 401,
        body: { 'message' => 'Unauthorised' }.to_json
      )
    end

    it 'raises Error401Exception' do
      expect { call }.to raise_exception(BaseApi::Error401Exception)
    end
  end

  context 'when the response status is 422' do
    before do
      stub_request(:post, %r{auth/login}).to_return(
        status: 422,
        body: { 'message' => 'Email unconfirmed' }.to_json
      )
    end

    it 'raises Error422Exception' do
      expect { call }.to raise_exception(BaseApi::Error422Exception)
    end
  end
end
