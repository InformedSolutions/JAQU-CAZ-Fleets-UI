# frozen_string_literal: true

require 'rails_helper'

describe 'CreateOrganisations::OrganisationsController - GET #new_credentials' do
  subject { get new_credentials_organisations_url }

  before do
    add_to_session(new_account: { 'account_id': @uuid })
    subject
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end
end
