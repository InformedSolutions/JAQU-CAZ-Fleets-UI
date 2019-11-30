# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #new_email_and_password' do
  subject { get email_address_and_password_path }

  before do
    add_to_session(company_name: 'Company name')
    subject
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end
end
