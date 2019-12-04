# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController - GET #new' do
  subject { get add_users_path }

  before do
    sign_in new_user
    subject
  end

  it 'returns an ok response' do
    expect(response).to have_http_status(:ok)
  end
end
