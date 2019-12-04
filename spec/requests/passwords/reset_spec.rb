# frozen_string_literal: true

require 'rails_helper'

describe 'PasswordsController - GET #reset', type: :request do
  subject { get reset_passwords_path }

  it 'returns an ok response' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
