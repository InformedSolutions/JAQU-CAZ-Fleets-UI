# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - GET #verification_failed' do
  subject { get verification_failed_organisations_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
