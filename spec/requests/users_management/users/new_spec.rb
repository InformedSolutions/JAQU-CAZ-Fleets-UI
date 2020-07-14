# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::UsersController - GET #new' do
  subject { get new_user_path }

  context 'correct permissions' do
    before { mock_users }

    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end
