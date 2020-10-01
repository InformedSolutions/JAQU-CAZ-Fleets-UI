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

    context 'when params are not valid' do
      let(:email) { '' }

      it 'renders the edit page' do
        expect(subject).to render_template(:edit)
      end
    end
  end
end
