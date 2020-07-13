# frozen_string_literal: true

require 'rails_helper'

describe 'CreateOrganisations::OrganisationsController - GET #email_verification' do
  subject { get email_verification_organisations_path(token: token) }

  let(:token) { 'token' }

  before { allow(CreateOrganisations::VerifyAccount).to receive(:call).and_return(:success) }

  it 'returns a redirect to :email_verified' do
    subject
    expect(response).to redirect_to(email_verified_organisations_path)
  end

  it 'calls CreateOrganisations::VerifyAccount with proper params' do
    expect(CreateOrganisations::VerifyAccount).to receive(:call).with(token: token)
    subject
  end

  context 'when verification is invalid' do
    before { allow(CreateOrganisations::VerifyAccount).to receive(:call).and_return(:invalid) }

    it 'returns a redirect to :verification_failed' do
      subject
      expect(response).to redirect_to(verification_failed_organisations_path)
    end
  end

  context 'when verification is expired' do
    before { allow(CreateOrganisations::VerifyAccount).to receive(:call).and_return(:expired) }

    it 'returns a redirect to :verification_expired' do
      subject
      expect(response).to redirect_to(verification_expired_organisations_path)
    end
  end
end
