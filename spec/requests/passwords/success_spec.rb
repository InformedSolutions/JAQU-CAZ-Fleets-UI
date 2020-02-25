# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #success', type: :request do
  subject(:http_request) { get success_passwords_path }

  it 'returns an ok response' do
    http_request
    expect(response).to have_http_status(:ok)
  end
end
