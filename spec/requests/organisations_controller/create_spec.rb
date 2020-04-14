# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - POST #create' do
  subject { post new_credentials_organisations_path, params: params }

  let(:params) { { organisations: organization_params } }
  let(:organization_params) do
    {
      email: email,
      email_confirmation: email,
      password: password,
      password_confirmation: password
    }
  end
  let(:user) { User.new(email: email, sub: SecureRandom.uuid) }
  let(:email) { 'email@example.com' }
  let(:company_name) { 'Company name' }
  let(:password) { '8NAOTpMkx2%9' }

  context 'with company name in the session' do
    before do
      allow(CreateAccount).to receive(:call).and_return(user)
      add_to_session('new_account': { 'company_name': company_name })
    end

    context 'with valid params' do
      it 'redirects to email sent page' do
        subject
        expect(response).to redirect_to(email_sent_organisations_path)
      end

      it 'calls CreateAccountService with proper params' do
        expect(CreateAccount)
          .to receive(:call)
          .with(
            organisations_params: strong_params(organization_params),
            company_name: company_name,
            host: root_url
          )
        subject
      end
    end

    context 'with invalid params' do
      before do
        allow(CreateAccount).to receive(:call).and_raise(NewPasswordException.new({}))
      end

      it 'renders account details view' do
        subject
        expect(response).to render_template('organisations/new_credentials')
      end
    end
  end

  context 'without company name in session' do
    it_behaves_like 'company name is missing'
  end
end
