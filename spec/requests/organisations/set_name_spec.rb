# frozen_string_literal: true

require 'rails_helper'

describe 'CreateOrganisations::OrganisationsController - POST #set_name' do
  subject do
    post organisations_path, params: { organisations: { company_name: company_name } }
  end

  let(:company_name) { 'Company Name' }

  context 'with valid params' do
    before do
      allow(CreateOrganisations::CreateAccount).to receive(:call).and_return(@uuid)
    end

    context 'when account_id not present in session' do
      it 'returns a found response' do
        subject
        expect(response).to have_http_status(:found)
      end

      it 'calls CreateOrganisations::CreateAccount service response' do
        subject
        expect(CreateOrganisations::CreateAccount).to have_received(:call)
      end
    end

    context 'when account_id present in session but name has been changed' do
      before do
        add_to_session(new_account: new_account_session)
        subject
      end

      let(:new_account_session) do
        {
          'account_id' => '76155935-33cb-4bb8-991a-e014621697be',
          'company_name' => 'Other Company Name'
        }
      end

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'calls CreateOrganisations::CreateAccount service response' do
        expect(CreateOrganisations::CreateAccount).to have_received(:call)
      end
    end

    context 'when account_id present in session and name has not been changed' do
      before do
        add_to_session(new_account: new_account_session)
        subject
      end

      let(:new_account_session) do
        {
          'account_id' => '76155935-33cb-4bb8-991a-e014621697be',
          'company_name' => company_name
        }
      end

      it 'returns a found response' do
        expect(response).to have_http_status(:found)
      end

      it 'does not call CreateOrganisations::CreateAccount service response' do
        expect(CreateOrganisations::CreateAccount).not_to have_received(:call)
      end
    end
  end

  context 'with invalid company_name' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(CreateOrganisations::CreateAccount).to(receive(:call)
        .and_raise(InvalidCompanyNameException, errors))
      subject
    end

    it 'renders create company name view' do
      expect(response).to render_template('organisations/new')
    end
  end

  context 'when error from the API ' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(CreateOrganisations::CreateAccount).to(receive(:call)
        .and_raise(UnableToCreateAccountException, errors))
      subject
    end

    it 'renders create company name view' do
      expect(response).to render_template('organisations/new')
    end
  end
end
