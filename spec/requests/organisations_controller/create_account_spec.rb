# frozen_string_literal: true

require 'rails_helper'

describe 'OrganisationsController - POST #create_account' do
  subject do
    post fleet_check_organisations_path, params: params
  end
  let(:params) { { organisations: { confirm_fleet_check: confirm_fleet_check } } }
  let(:confirm_fleet_check) { 'less_than_two' }

  context 'with valid params' do
    before do
      allow(CreateAccount).to receive(:call).and_return(SecureRandom.uuid)
      subject
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'with invalid params' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(CreateAccount).to(receive(:call)
        .and_raise(InvalidCompanyCreateException, errors))
      subject
    end

    it 'renders create company name view' do
      expect(response).to render_template('organisations/fleet_check')
    end
  end

  context 'when service throw AccountForMultipleVehiclesException exception' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(CreateAccount).to(receive(:call)
        .and_raise(AccountForMultipleVehiclesException, errors))
      subject
    end

    it 'renders create company name view' do
      expect(response).to redirect_to(cannot_create_organisations_path)
    end
  end

  context 'when service throw AccountForMultipleVehiclesException exception' do
    let(:errors) { { company_name: 'Sample Error' } }

    before do
      allow(CreateAccount).to(receive(:call)
        .and_raise(UnableToCreateAccountException, errors))
      subject
    end

    it 'renders create company name view' do
      expect(response).to redirect_to(organisations_path)
    end
  end
end
