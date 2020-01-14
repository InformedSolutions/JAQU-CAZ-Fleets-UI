# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - POST #set_name' do
  subject do
    post organisations_path, params: { organisations: { company_name: company_name } }
  end

  let(:company_name) { 'Company Name' }

  before { subject }

  context 'with valid params' do
    it 'returns a success response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'with invalid params' do
    let(:company_name) { '' }

    it 'renders create company name view' do
      expect(response).to render_template('organisations/new')
    end
  end
end
