# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::EmailsController - GET #resend_email' do
  subject { get resend_email_primary_users_path }

  let(:owner_email) { 'new@email.com' }

  before do
    allow(AccountDetails::Api).to receive(:update_owner_email).and_return(true)
    sign_in create_owner
    add_to_session(owners_new_email: owner_email)
    subject
  end

  it 'calls AccountDetails::Api.update_owner_email method' do
    expect(AccountDetails::Api).to have_received(:update_owner_email)
  end

  it 'redirects to email sent page' do
    expect(response).to redirect_to(email_sent_primary_users_path)
  end
end
