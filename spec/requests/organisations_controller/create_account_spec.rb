# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - POST #create_account' do
  subject do
    post create_account_name_path, params:
  {
    company:
      {
        email: 'email@example.com',
        email_confirmation: 'email@example.com',
        password: '8NAOTpMkx2%9',
        password_confirmation: '8NAOTpMkx2%9'
      }
  }
  end

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
