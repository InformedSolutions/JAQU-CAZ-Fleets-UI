# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #index' do
  subject { get fleets_path }

  context 'correct permissions' do
    before { sign_in manage_vehicles_user }

    context 'with empty fleet' do
      before { mock_fleet(create_empty_fleet) }

      it 'redirects to  #submission_method' do
        subject
        expect(response).to redirect_to submission_method_fleets_path
      end
    end

    context 'with vehicles in fleet' do
      before do
        mock_fleet
        mock_caz_list
        subject
      end

      it 'renders manage vehicles page' do
        expect(response).to render_template('fleets/index')
      end

      it 'sets default page value to 1' do
        expect(assigns(:pagination).page).to eq(1)
      end
    end

    context 'with invalid page' do
      before do
        allow(FleetsApi).to receive(:fleet_vehicles).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        subject
      end

      it 'redirects to fleets page' do
        expect(response).to redirect_to fleets_path
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
