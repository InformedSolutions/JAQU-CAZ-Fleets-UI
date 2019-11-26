# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #create_name', type: :request do
  subject do
    post create_account_name_path, params: { email_and_password_form: { name: 'Company Name' } }
  end

  skip it 'returns a success response' do
    subject
    expect(response).to have_http_status(:found)
  end
end
