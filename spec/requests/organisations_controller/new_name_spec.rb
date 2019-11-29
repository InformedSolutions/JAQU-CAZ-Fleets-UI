# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #new_name' do
  subject { get create_account_name_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
