# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #create_account', type: :request do
  subject { post create_account_name_path, params: { company: { name: 'Company Name' } } }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:found)
  end
end
