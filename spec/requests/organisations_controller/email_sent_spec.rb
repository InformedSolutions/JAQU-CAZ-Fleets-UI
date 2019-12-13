# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #email_sent' do
  subject { get email_sent_organisations_path }

  let(:session_data) do
    { company_name: 'Company name', new_account: create_user.serializable_hash }
  end

  before do
    add_to_session(session_data)
    subject
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end

  context 'without new_account data in the session' do
    let(:session_data) { { company_name: 'Company name' } }

    it 'returns a redirect' do
      expect(response).to redirect_to(root_path)
    end
  end
end
