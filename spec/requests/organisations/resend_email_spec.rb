# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - GET #resend_email' do
  subject { get resend_email_organisations_path }

  let(:user) { create_user }
  let(:session_data) do
    { new_account: create_user.serializable_hash.merge(account_id: SecureRandom.uuid) }
  end

  before do
    add_to_session(session_data)
    allow(AccountsApi).to receive(:resend_verification).and_return(true)
  end

  it 'calls AccountApi to resend the email' do
    subject
    expect(AccountsApi).to have_received(:resend_verification)
  end

  it 'returns a redirect to email_sent' do
    subject
    expect(response).to redirect_to(email_sent_organisations_path)
  end

  context 'without new_account data in the session' do
    let(:session_data) { { new_account: { 'account_id': SecureRandom.uuid } } }

    it 'does not call AccountApi to resend the email' do
      subject
      expect(AccountsApi).not_to have_received(:resend_verification)
    end

    it 'returns a redirect to root_path' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
