# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::EmailsController - GET #update' do
  subject { get update_email_primary_users_path, params: params }

  let(:params) { { email: email } }
  let(:email) { 'carl.gustav@jung.com' }

  before { sign_in create_owner }

  context 'when params are valid' do
    context 'when user is successfully updated' do
      before do
<<<<<<< HEAD
        allow(AccountsApi::Accounts).to receive(:user_validations).and_return(true)
        allow(AccountsApi::Auth).to receive(:update_owner_email).and_return(true)
=======
        allow(AccountsApi).to receive(:user_validations).and_return(true)
        allow(AccountDetails::Api).to receive(:update_owner_email).and_return(true)
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
      end

      it 'updates owners email through API' do
        subject
<<<<<<< HEAD
        expect(AccountsApi::Auth).to have_received(:update_owner_email)
=======
        expect(AccountDetails::Api).to have_received(:update_owner_email)
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
      end

      # TODO: CAZB-2640
      it 'redirects to email sent page'
    end

    context 'when params are not valid' do
      let(:email) { '' }

<<<<<<< HEAD
      it 'renders the view' do
        expect(subject).to render_template(:edit_email)
=======
      it 'renders the edit page' do
        expect(subject).to render_template(:edit)
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
      end
    end
  end
end
