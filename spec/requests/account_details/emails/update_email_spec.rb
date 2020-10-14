# frozen_string_literal: true

require 'rails_helper'

describe 'AccountDetails::EmailsController - GET #update_email' do
  subject { get update_email_primary_users_path, params: params }

  before { sign_in user }

  let(:user) { create_owner }
  let(:params) { { email: email } }
  let(:email) { 'carl.gustav@jung.com' }

  context 'when params are valid' do
    context 'when user is successfully updated' do
      before do
        allow(AccountsApi).to receive(:user_validations).and_return(true)
        allow(AccountDetails::Api).to receive(:update_owner_email).and_return(true)
      end

      it 'updates owners email through API' do
        subject
        expect(AccountDetails::Api).to have_received(:update_owner_email)
      end

      # TODO: CAZB-2640
      it 'redirects to email sent page'
    end

    context 'when user save no changes' do
      let(:email) { user.email }

<<<<<<< HEAD:spec/requests/account_details/emails/update_spec.rb
<<<<<<< HEAD
      it 'renders the view' do
        expect(subject).to render_template(:edit_email)
=======
      it 'renders the edit page' do
        expect(subject).to render_template(:edit)
>>>>>>> 83c4759... [CAZB-2856] Update email page (#617)
=======
      it 'redirects to the account details page' do
        expect(subject).to redirect_to(primary_users_account_details_path)
>>>>>>> 4bca06e... [CAZB-2639] Redirect to the account details when save no changes (#654):spec/requests/account_details/emails/update_email_spec.rb
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
