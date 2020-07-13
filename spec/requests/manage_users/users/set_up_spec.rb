# frozen_string_literal: true

require 'rails_helper'

describe UsersManagement::UsersController, type: :request do
  describe 'GET #set_up' do
    subject { get set_up_users_path }

    it_behaves_like 'incorrect permissions'

    before { mock_users }
    it_behaves_like 'a login required'
  end
end