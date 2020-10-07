# frozen_string_literal: true

require 'rails_helper'

describe 'AccountsDetails::EmailsController - GET #validate_confirm_email' do
  subject do
    get validate_confirm_email_primary_users_path(
      token: 'token',
      params: {
        passwords: {
          password: 'password',
          password_confirmation: 'password'
        }
      }
    )
  end

  context 'when user is an owner' do
    before do
      stub = instance_double('AccountDetails::UpdateEmail',
                             valid?: valid?,
                             errors: [])
      allow(AccountDetails::UpdateEmail).to receive(:call).and_return(stub)
      sign_in create_owner
      subject
    end

    let(:valid?) { true }

    context 'when params are valid' do
      it 'redirects to the dashboard' do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when params are not valid' do
      let(:valid?) { false }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view' do
        expect(response).to render_template(:confirm_email)
      end
    end
  end

  context 'when user is not an owner' do
    before { sign_in create_user }

    it 'redirects to the not found page' do
      expect(subject).to redirect_to(not_found_path)
    end
  end
end
