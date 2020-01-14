# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - GET #new' do
  subject { get organisations_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
