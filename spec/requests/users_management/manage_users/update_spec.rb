# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::ManageUsersController - PATCH #update' do
  subject { patch user_path(@uuid), params: params }

  let(:params) { { edit_user: permissions } }
  let(:permissions) { { permissions: %w[MAKE_PAYMENTS] } }

  context 'correct permissions' do
    before { sign_in manage_users_user }

    context 'when user is exist in db' do
      before do
        mock_update_user
        mock_users
      end

      it 'redirects to the users page' do
        expect(subject).to redirect_to(users_path)
      end
    end

    context 'when permissions is nil' do
      before { subject }

      let(:permissions) { nil }

      it 'redirects to the users page' do
        expect(response).to redirect_to(edit_user_path(@uuid))
      end

      it 'sets the proper error message' do
        expect(flash[:errors]).to eq('Select at least one permission type to continue')
      end
    end

    context 'when user is not exist in db' do
      before do
        allow(AccountsApi).to receive(:update_user)
          .and_raise(BaseApi::Error404Exception.new(404, '', {}))
      end

      it 'redirects to not_found page' do
        expect(subject).to redirect_to not_found_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
  it_behaves_like 'a login required'
end
