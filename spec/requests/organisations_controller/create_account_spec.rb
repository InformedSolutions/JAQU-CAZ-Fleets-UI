# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrganisationsController - POST #create_account' do
  subject { post email_address_and_password_path, params: params }

  let(:params) do
    {
      organisations:
        {
          email: email,
          email_confirmation: email,
          password: '8NAOTpMkx2%9',
          password_confirmation: '8NAOTpMkx2%9'
        }
    }
  end

  let(:email) { 'email@example.com' }

  context 'with company name in the session' do
    before do
      add_to_session(company_name: 'Company name')
      subject
    end

    context 'with valid params' do
      it 'redirects to email sent page' do
        expect(response).to redirect_to(email_sent_path)
      end
    end

    context 'with invalid params' do
      let(:email) { '' }

      it 'renders account details view' do
        expect(response).to render_template('organisations/new_email_and_password')
      end
    end
  end

  context 'without company name in session' do
    it_behaves_like 'company name is missing'
  end
end
