# frozen_string_literal: true

require 'rails_helper'

describe 'Organisations::OrganisationsController - POST #create_account', type: :request do
  subject { post create_account_path, params: { organisations: { company_name: company_name } } }

  let(:company_name) { 'Company Name' }

  context 'with valid params' do
    before { allow(Organisations::CreateAccount).to receive(:call).and_return(@uuid) }

    context 'when account_id not present in session' do
      it 'returns a found response' do
        subject
        expect(response).to have_http_status(:found)
      end

      it 'calls Organisations::CreateAccount service response' do
        subject
        expect(Organisations::CreateAccount).to have_received(:call)
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

      it 'calls Organisations::CreateAccount service response' do
        expect(Organisations::CreateAccount).to have_received(:call)
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

      it 'does not call Organisations::CreateAccount service response' do
        expect(Organisations::CreateAccount).not_to have_received(:call)
      end
    end
  end

  context 'with invalid company_name' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(Organisations::CreateAccount).to(receive(:call).and_raise(InvalidCompanyNameException, errors))
      subject
    end

    it 'renders the view' do
      expect(response).to render_template(:create_account)
    end
  end

  context 'when error from the API ' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(Organisations::CreateAccount).to(receive(:call).and_raise(UnableToCreateAccountException, errors))
      subject
    end

    it 'renders the view' do
      expect(response).to render_template(:create_account)
    end
  end
end
