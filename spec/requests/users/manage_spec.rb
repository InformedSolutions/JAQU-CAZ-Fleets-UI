# frozen_string_literal: true

require 'rails_helper'

describe 'UsersController - GET #manage' do
  subject { get manage_users_path }

  before do
    sign_in create_admin
    subject
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end
end
