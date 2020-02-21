# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi.initiate_password_reset' do
  subject(:call) { AccountsApi.initiate_password_reset(email: email) }

  let(:email) { 'test@example.com' }
  let(:url) { %r{auth/password/reset} }

  before do
    stub_request(:post, url).to_return(
      status: 204,
      body: nil
    )
  end

  it 'calls API with proper body' do
    call
    expect(WebMock)
      .to have_requested(:post, url)
      .with(body: { email: email })
      .once
  end

  it 'returns true' do
    expect(call).to be_truthy
  end
end
