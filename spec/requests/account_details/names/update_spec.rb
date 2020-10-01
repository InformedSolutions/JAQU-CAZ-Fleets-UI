# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::NamesController - GET #update' do
  subject { get update_name_non_primary_users_path, params: params }

  let(:params) { { name: name } }
  let(:name) { 'Carl Gustav Jung' }

  before { sign_in create_user }

  context 'when params are valid' do
    context 'when user is successfully updated' do
      before do
        allow(AccountsApi).to receive(:update_user).and_return(true)
      end

      it 'updates user through API' do
        subject
        expect(AccountsApi).to have_received(:update_user)
      end

      it 'redirects user to non_primary_users_account_details_path' do
        expect(subject).to redirect_to(non_primary_users_account_details_path)
      end
    end
  end

  context 'when params are not valid' do
    let(:name) { '' }

    it 'renders the edit name page' do
      expect(subject).to render_template(:edit)
    end
  end
end
