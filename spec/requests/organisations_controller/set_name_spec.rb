# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - POST #set_name' do
  subject do
    post organisations_path, params: { organisations: { company_name: company_name } }
  end

  let(:company_name) { 'Company Name' }

  context 'with valid params' do
    before do
      allow(CheckCompanyName).to receive(:call).and_return(SecureRandom.uuid)
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:found)
    end

    it 'returns a success response' do
      expect(response).to redirect_to(fleet_check_organisations_path)
    end
  end

  context 'with invalid params' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(CheckCompanyName).to(receive(:call)
        .and_raise(InvalidCompanyNameException, errors))
      subject
    end

    it 'renders create company name view' do
      expect(response).to render_template('organisations/new')
    end
  end
end
