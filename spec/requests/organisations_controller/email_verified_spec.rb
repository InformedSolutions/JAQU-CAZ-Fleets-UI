# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #email_verified' do
  subject { get email_verified_organisations_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
