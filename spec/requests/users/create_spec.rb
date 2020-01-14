# frozen_string_literal: true

require 'rails_helper'

describe 'UsersController - POST #create' do
  subject(:http_request) do
    post add_users_path, params: { users: user_params }
  end

  let(:user_params) do
    {
      name: name,
      email_address: email_address
    }
  end

  let(:name) { 'User Name' }
  let(:email_address) { 'example@email.com' }

  before do
    sign_in create_admin
    http_request
  end

  context 'with valid params' do
    it 'redirects to manage users page' do
      subject
      expect(response).to redirect_to(manage_users_path)
    end
  end

  context 'with invalid params' do
    let(:name) { '' }

    it 'renders add users view' do
      subject
      expect(response).to render_template('users/new')
    end
  end
end
