# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsersController - GET #confirm_manage' do
  subject(:http_request) do
    post manage_users_path, params: { 'confirm-admin-creation' => confirmation }
  end

  let(:confirmation) { 'yes' }

  before do
    sign_in new_user
    http_request
  end

  context 'when user confirms form' do
    it 'redirects to add users page ' do
      expect(response).to redirect_to(add_users_path)
    end
  end

  context 'when user does not confirm details' do
    let(:confirmation) { 'no' }

    it 'redirects to dashboard page' do
      expect(response).to redirect_to(dashboard_path)
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    it 'redirects to manage users page' do
      expect(response).to redirect_to(manage_users_path)
    end
  end
end
