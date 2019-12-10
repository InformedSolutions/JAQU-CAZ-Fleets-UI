# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #email_verification' do
  subject { get email_verification_path(token: token) }

  let(:token) { 'token' }

  before { allow(VerifyAccount).to receive(:call).and_return(true) }

  it 'returns a redirect to :email_verified' do
    subject
    expect(response).to redirect_to(email_verified_path)
  end

  it 'calls VerifyAccount with proper params' do
    expect(VerifyAccount).to receive(:call).with(token: token)
    subject
  end

  context 'when verification is unsuccessful' do
    before { allow(VerifyAccount).to receive(:call).and_return(false) }

    it 'returns a redirect to :verification_failed' do
      subject
      expect(response).to redirect_to(verification_failed_path)
    end
  end
end
