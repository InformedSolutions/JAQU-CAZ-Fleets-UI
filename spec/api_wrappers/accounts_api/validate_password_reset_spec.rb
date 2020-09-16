# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsApi.validate_password_reset - POST' do
  subject { AccountsApi.validate_password_reset(token: token) }

  let(:token) { @uuid }
  let(:url) { %r{auth/password/reset/validation} }

  before do
    stub_request(:post, url).to_return(
      status: 204,
      body: nil
    )
  end

  it 'calls API with proper body' do
    subject
    expect(WebMock)
      .to have_requested(:post, url)
      .with(body: { token: token })
      .once
  end

  it 'returns true' do
    expect(subject).to be_truthy
  end
end
