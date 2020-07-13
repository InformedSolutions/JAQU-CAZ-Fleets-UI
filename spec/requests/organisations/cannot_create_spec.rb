# frozen_string_literal: true

require 'rails_helper'

describe 'CreateOrganisations::OrganisationsController - GET #cannot_create' do
  subject { get cannot_create_organisations_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
