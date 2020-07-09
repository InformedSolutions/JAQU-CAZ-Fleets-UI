# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::UsersController, type: :request do
  describe 'GET #add_permissions' do
    subject { get add_permissions_users_path }

    it_behaves_like 'incorrect permissions'

    before do
      mock_users
      data = {
        new_user: {
          email: 'new_user@example.com',
          name: 'New User'
        }
      }
      add_to_session(data)
    end
    it_behaves_like 'a login required'
  end
end
