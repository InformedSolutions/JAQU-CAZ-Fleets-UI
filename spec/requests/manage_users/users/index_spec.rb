# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::UsersController, type: :request do
  describe 'GET #index' do
    subject { get users_path }

    it_behaves_like 'incorrect permissions'

    before { mock_users }
    it_behaves_like 'a login required'
  end
end