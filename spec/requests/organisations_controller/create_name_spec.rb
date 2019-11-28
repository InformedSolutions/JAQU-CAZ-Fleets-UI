# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - POST #create_name', type: :request do
  subject do
    post create_account_name_path, params: { company: { company_name: 'Company Name' } }
  end

  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:found)
  end
end
