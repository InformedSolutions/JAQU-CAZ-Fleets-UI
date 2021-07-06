# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::RemoveVehiclesController - GET #remove_vehicles', type: :request do
  subject { get remove_vehicles_fleets_path, params: { vrn_search: nil } }

  context 'when correct permissions' do
    before { sign_in user }

    let(:user) { manage_vehicles_user }

    context 'with empty fleet' do
      before { mock_fleet(create_empty_fleet) }

      it 'redirects to the #choose_method' do
        subject
        expect(response).to redirect_to choose_method_fleets_path
      end
    end

    context 'with vehicles in fleet' do
      before { mock_clean_air_zones }

      context 'with api returns 200 status' do
        before do
          mock_fleet
          subject
        end

        it 'returns a 200 OK status' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the view' do
          expect(response).to render_template(:remove_vehicles)
        end

        it 'sets default page value to 1' do
          expect(assigns(:pagination).page).to eq(1)
        end

        it 'sets default per_page value to 10' do
          expect(assigns(:pagination).per_page).to eq(10)
        end

        it 'not sets :success flash message' do
          expect(flash[:success]).to be_nil
        end

        it_behaves_like 'sets cache headers'
      end

      context 'with api returns 404 status' do
        before do
          mock_fleet
          allow(FleetsApi).to receive(:job_status)
            .and_raise(BaseApi::Error404Exception.new(404, '', {}))
          subject
        end

        it 'returns a 200 OK status' do
          expect(response).to have_http_status(:ok)
        end

        it 'render the view' do
          expect(response).to render_template(:remove_vehicles)
        end
      end

      context 'with search data' do
        before do
          mock_fleet
          add_to_session(remove_vehicles_vrn_search: vrn)
        end

        let(:vrn) { 'ABC123' }

        context 'with a valid search value' do
          before { subject }

          it 'returns a 200 OK status' do
            expect(response).to have_http_status(:ok)
          end

          it 'assigns vrn value' do
            expect(assigns(:vrn)).to eq(vrn)
          end
        end

        context 'with an invalid search value' do
          let(:vrn) { 'ABCDE$%' }

          before { subject }

          it 'returns a 200 OK status' do
            expect(response).to have_http_status(:ok)
          end

          it 'render the view' do
            expect(response).to render_template(:remove_vehicles)
          end

          it 'assigns vrn value' do
            expect(assigns(:vrn)).to eq(vrn)
          end

          it 'assigns flash error message' do
            expect(flash[:alert]).to eq('Enter the number plate of the vehicle in a valid format')
          end
        end
      end
    end

    context 'with invalid page' do
      before do
        allow(FleetsApi).to receive(:vehicles).and_raise(
          BaseApi::Error400Exception.new(400, '', {})
        )
        subject
      end

      it 'redirects to the remove vehicles page' do
        expect(response).to redirect_to(remove_vehicles_fleets_path)
      end

      it 'not sets :success flash message' do
        expect(flash[:success]).to be_nil
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
