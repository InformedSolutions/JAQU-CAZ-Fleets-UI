# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::UsersController, type: :request do
  describe 'GET #new' do
    subject { get new_user_path }

    it_behaves_like 'incorrect permissions'

    before { mock_users }
    it_behaves_like 'a login required'
  end
end
