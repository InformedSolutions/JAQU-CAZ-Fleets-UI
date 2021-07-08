# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - DELETE #delete_vehicle', type: :request do
  subject { delete confirm_remove_vehicle_fleets_path, params: { 'confirm-delete': confirmation } }

  let(:confirmation) { 'yes' }

  context 'when correct permissions' do
    before do
      sign_in(user)
      allow(FleetsApi).to receive(:remove_vehicle_from_fleet).and_return(true)
      add_to_session(remove_vehicles_list: vrns)
    end

    let(:user) { manage_vehicles_user(account_id: account_id) }
    let(:account_id) { SecureRandom.uuid }
    let(:vrns) { [vrn] }
    let(:vrn) { 'ABC123' }

    context 'when confirmation is `yes`' do
      context 'with empty fleet' do
        before do
          mock_fleet(create_empty_fleet)
          subject
        end

        it 'calls FleetsApi.remove_vehicle_from_fleet with proper params' do
          expect(FleetsApi).to have_received(:remove_vehicle_from_fleet).with(account_id: account_id,
                                                                              vrn: vrn)
        end

        it 'assigns flash success message' do
          expect(flash[:success]).to eq('You have successfully removed ABC123 from your vehicle list.')
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
          expect(FleetsApi).to have_received(:remove_vehicle_from_fleet).with(account_id: account_id,
                                                                              vrn: vrn)
        end

        it 'assigns flash success message' do
          expect(flash[:success]).to eq('You have successfully removed ABC123 from your vehicle list.')
        end

        it 'redirects to manage vehicles page' do
          expect(response).to redirect_to(fleets_path)
        end
      end
    end

    context 'when confirmation is `no`' do
      let(:confirmation) { 'no' }

      before { subject }

      it 'not calls FleetsApi.remove_vehicle_from_fleet' do
        expect(FleetsApi).not_to have_received(:remove_vehicle_from_fleet)
      end

      it 'not assigns flash success message' do
        expect(flash[:success]).to be_nil
      end

      it 'redirects to edit vehicles page' do
        expect(response).to redirect_to(edit_fleets_path)
      end
    end

    context 'when confirmation is `nil`' do
      let(:confirmation) { nil }

      before { subject }

      it 'assigns flash error message' do
        expect(flash[:alert]).to eq('You must choose an answer')
      end

      it 'renders the view' do
        expect(response).to render_template(:confirm_remove_vehicle)
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
