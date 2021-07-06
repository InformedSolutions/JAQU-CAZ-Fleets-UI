# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - DELETE #delete_vehicles', type: :request do
  subject { delete confirm_remove_vehicles_fleets_path }

  context 'when correct permissions' do
    before do
      sign_in(user)
      allow(FleetsApi).to receive(:remove_vehicles_from_fleet).and_return(true)
      add_to_session(remove_vehicles_list: vrns)
    end

    let(:user) { manage_vehicles_user(account_id: account_id) }
    let(:account_id) { SecureRandom.uuid }
    let(:vrns) { %w[ABC123 XYZ123] }

    context 'with empty fleet' do
      before do
        mock_fleet(create_empty_fleet)
        subject
      end

      it 'calls FleetsApi.remove_vehicles_from_fleet with proper params' do
        expect(FleetsApi).to have_received(:remove_vehicles_from_fleet).with(account_id: account_id,
                                                                             vehicles: vrns)
      end

      it 'assigns flash success message' do
        expect(flash[:success]).to eq('You have successfully removed 2 vehicles from your vehicle list.')
      end

      it 'redirects to dashboard page' do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'with vehicles in fleet' do
      before do
        mock_fleet
        subject
      end

      it 'calls FleetsApi.remove_vehicles_from_fleet with proper params' do
        expect(FleetsApi).to have_received(:remove_vehicles_from_fleet).with(account_id: account_id,
                                                                             vehicles: vrns)
      end

      it 'assigns flash success message' do
        expect(flash[:success]).to eq('You have successfully removed 2 vehicles from your vehicle list.')
      end

      it 'redirects to manage vehicles page' do
        expect(response).to redirect_to(fleets_path)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
