# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::CreateUsersController - POST #create' do
  subject { post users_path, params: params }

  let(:params) { { new_user: { 'name': name, 'email': email } } }
  let(:name) { 'New User' }
  let(:email) { 'new_user@example.com' }

  context 'correct permissions' do
    before do
      add_to_session({ new_user: { name: name, email: email } })
      sign_in manage_users_user
      mock_users
      allow(AccountsApi).to receive(:user_validations).and_return(true)
    end

    it 'redirects to add permissions page' do
      expect(subject).to redirect_to(add_permissions_users_path)
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
