# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - POST #submit_remove_vehicles', type: :request do
  subject { post remove_vehicles_fleets_path, params: params }

  let(:params) do
    {
      commit: commit,
      vehicles: vehicles,
      vrn_search: vrn_search,
      vrns_on_page: vehicles.to_s
    }
  end
  let(:commit) { 'Continue' }
  let(:vrn_search) { 'XYZ123' }
  let(:vehicles) { [vrn] }
  let(:vrn) { 'ABC123' }

  context 'when correct permissions' do
    before do
      mock_fleet
      sign_in(create_user)
    end

    context 'with valid params' do
      before do
        add_to_session(remove_vehicles_list: vehicles)
        subject
      end

      context 'when single vehicle was selected' do
        context 'when commit is `CONTINUE`' do
          it 'redirects to the confirm remove vehicle page' do
            expect(response).to redirect_to(confirm_remove_vehicle_fleets_path)
          end

          it 'saves updates `remove_vehicles_list` data in session' do
            expect(session[:remove_vehicles_list]).to eq(vehicles)
          end
        end

        context 'when commit is `SEARCH`' do
          let(:commit) { 'SEARCH' }

          before { subject }

          it 'redirects to the remove vehicles page' do
            expect(response).to redirect_to(remove_vehicles_fleets_path(page: 1))
          end

          it 'updates `remove_vehicles_list` in session' do
            expect(session[:remove_vehicles_list]).to eq(vehicles)
          end

          it 'updates `remove_vehicles_vrn_search` in session' do
            expect(session[:remove_vehicles_vrn_search]).to eq(vrn_search)
          end
        end
      end

      context 'when multiple vehicles were selected' do
        let(:vehicles) { [vrn, vrn] }

        context 'when commit is `CONTINUE`' do
          it 'redirects to the confirm remove vehicle page' do
            expect(response).to redirect_to(confirm_remove_vehicles_fleets_path)
          end

          it 'saves updates `remove_vehicles_list` data in session' do
            expect(session[:remove_vehicles_list]).to eq(vehicles)
          end
        end

        context 'when commit is `SEARCH`' do
          let(:commit) { 'SEARCH' }

          before { subject }

          it 'redirects to the remove vehicles page' do
            expect(response).to redirect_to(remove_vehicles_fleets_path(page: 1))
          end

          it 'updates `remove_vehicles_list` in session' do
            expect(session[:remove_vehicles_list]).to eq(vehicles)
          end

          it 'updates `remove_vehicles_vrn_search` in session' do
            expect(session[:remove_vehicles_vrn_search]).to eq(vrn_search)
          end
        end
      end
    end

    context 'without valid params' do
      before { post remove_vehicles_fleets_path, params: { commit: commit } }

      it 'renders the view' do
        expect(subject).to render_template(:remove_vehicles)
      end

      it 'assigns flash error message' do
        expect(flash[:alert]).to eq('You must select a vehicle')
      end

      it 'assigns fleet variable' do
        expect(assigns(:fleet)).not_to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
