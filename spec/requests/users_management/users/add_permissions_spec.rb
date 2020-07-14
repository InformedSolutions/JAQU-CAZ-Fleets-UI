# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::UsersController - GET #add_permissions' do
  subject { get add_permissions_users_path }

  context 'correct permissions' do
    before do
      mock_users
      add_to_session({ new_user: { email: 'new_user@example.com', name: 'New User' } })
    end

    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end
