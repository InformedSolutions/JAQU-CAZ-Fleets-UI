# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #email_sent' do
  subject { get email_sent_path }

  before do
    add_to_session(company_name: 'Company name')
    subject
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end
end
