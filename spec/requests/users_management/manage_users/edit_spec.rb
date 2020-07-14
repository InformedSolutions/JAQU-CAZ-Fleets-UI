# frozen_string_literal: true

require 'rails_helper'

describe 'UsersManagement::ManageUsersController - GET #edit' do
  subject { get edit_user_path(@uuid) }

  context 'correct permissions' do
    before { sign_in manage_users_user }

    context 'when user is exist in db' do
      before { mock_user_details }

      it 'renders the view' do
        expect(subject).to render_template('edit')
      end
    end

    context 'when user is not exist in db' do
      before do
        allow(AccountsApi).to receive(:user)
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
