# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController - GET #email_verified', type: :request do
  subject { get email_verified_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
