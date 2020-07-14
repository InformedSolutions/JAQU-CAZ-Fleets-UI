# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::UsersController - GET #set_up' do
  subject { get set_up_users_path }

  context 'correct permissions' do
    before { mock_users }

    it_behaves_like 'a login required'
  end

  it_behaves_like 'incorrect permissions'
end