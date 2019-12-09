# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - GET #verification_failed' do
  subject { get verification_failed_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
