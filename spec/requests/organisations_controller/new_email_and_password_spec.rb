# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #new_email_and_password' do
  subject { get email_address_and_password_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:found)
  end
end
