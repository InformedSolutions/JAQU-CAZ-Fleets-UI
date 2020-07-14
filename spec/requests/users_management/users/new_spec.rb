# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::UsersController - GET #new' do
  subject { get new_user_path }

  context 'correct permissions' do
    before do
      sign_in manage_users_user
      mock_users
    end

    it 'renders the view' do
      expect(subject).to render_template('new')
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
