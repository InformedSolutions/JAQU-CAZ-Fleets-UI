# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - GET #resend_email' do
  subject { get resend_email_organisations_path }

  let(:user) { create_user }
  let(:session_data) do
    { 'new_account': create_user.serializable_hash.merge(company_name: 'Company name') }
  end

  before do
    allow(Sqs::VerificationEmail).to receive(:call).and_return(SecureRandom.uuid)
    add_to_session(session_data)
  end

  it 'returns a redirect to email_sent' do
    subject
    expect(response).to redirect_to(email_sent_organisations_path)
  end

  it 'calls Sqs::VerificationEmail with proper data' do
    # This is not the same instance of user as it was serialized
    expect(Sqs::VerificationEmail)
      .to receive(:call)
      .with(user: instance_of(User), host: root_url)
    subject
  end

  context 'without new_account data in the session' do
    let(:session_data) { { 'new_account': { 'company_name': 'Company name' } } }

    it 'returns a redirect to root_path' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
