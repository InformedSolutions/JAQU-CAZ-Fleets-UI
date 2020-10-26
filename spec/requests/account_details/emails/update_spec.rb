# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::EmailsController - GET #update_email' do
  subject { get update_email_primary_users_path, params: params }

  before { sign_in user }

  let(:user) { create_owner }
  let(:params) { { email: email, confirmation: confirmation } }
  let(:email) { 'carl.gustav@jung.com' }
  let(:confirmation) { 'carl.gustav@jung.com' }

  context 'when params are valid' do
    context 'when user is successfully updated' do
      before do
        allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true)
        allow(AccountsApi::Auth).to receive(:update_owner_email).and_return(true)
      end

      it 'updates owners email through API' do
        subject
        expect(AccountsApi::Auth).to have_received(:update_owner_email)
      end

      it 'redirects to email sent page' do
        expect(subject).to redirect_to(email_sent_primary_users_path)
      end
    end

    context 'when user save no changes' do
      let(:email) { user.email }
      let(:confirmation) { user.email }

      it 'redirects to the account details page' do
        expect(subject).to redirect_to(primary_users_account_details_path)
      end
    end
  end

  context 'when params are not valid' do
    let(:email) { '' }

    it 'renders the view' do
      expect(subject).to render_template(:edit_email)
    end
  end
end