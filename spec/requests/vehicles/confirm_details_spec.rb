# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleCheckersController - POST #confirm_details', type: :request do
  subject(:http_request) do
    post confirm_details_vehicles_path, params: { 'confirm-vehicle' => confirmation }
  end

  let(:confirmation) { 'yes' }
  let(:account_id) { SecureRandom.uuid }

  it 'returns redirect to the login page' do
    http_request
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is signed in' do
    before { sign_in create_user(account_id: account_id) }

    context 'without VRN in the session' do
      it 'returns redirect to vehicles#enter_details' do
        http_request
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end

    context 'with VRN in the session' do
      before do
        allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
        add_to_session(vrn: @vrn)
      end

      context 'when user confirms details' do
        it 'redirects to fleets' do
          http_request
          expect(response).to redirect_to(fleets_path)
        end

        it 'adds the vehicle to the fleet' do
          expect(FleetsApi)
            .to receive(:add_vehicle_to_fleet)
            .with(vrn: @vrn, account_id: account_id)
          http_request
        end

        it 'removes vrn from session' do
          http_request
          expect(session[:vrn]).to be_nil
        end

        it 'sets :success flash message' do
          http_request
          expect(flash[:success])
            .to eq("You have successfully added #{@vrn} to your vehicle list.")
        end

        context 'when the vehicle already exists in the fleet' do
          let(:message) { 'AccountVehicle already exists' }

          before do
            allow(FleetsApi)
              .to receive(:add_vehicle_to_fleet)
              .and_raise(
                BaseApi::Error422Exception.new(422, '', message: message)
              )
          end

          it 'sets :warning flash message' do
            http_request
            expect(flash[:warning])
              .to eq("#{@vrn} already exists in your vehicle list.")
          end
        end

        context 'when the call fails' do
          let(:message) { 'Test exception message' }

          before do
            allow(FleetsApi)
              .to receive(:add_vehicle_to_fleet)
              .and_raise(
                BaseApi::Error400Exception.new(400, '', message: message)
              )
          end

          it 'renders enter_details' do
            http_request
            expect(response).to render_template(:enter_details)
          end

          it 'displays an error' do
            http_request
            expect(response.body).to include(message)
          end
        end
      end

      context 'when user does not confirm details' do
        let(:confirmation) { 'no' }

        it 'redirects to incorrect details page' do
          http_request
          expect(response).to redirect_to(incorrect_details_vehicles_path)
        end

        it 'does not add the vehicle to the fleet' do
          expect(FleetsApi).not_to receive(:add_vehicle_to_fleet)
          http_request
        end
      end

      context 'when confirmation is empty' do
        let(:confirmation) { '' }

        it 'redirects to confirm details page' do
          http_request
          expect(response).to redirect_to(details_vehicles_path)
        end

        it 'does not add the vehicle to the fleet' do
          expect(FleetsApi).not_to receive(:add_vehicle_to_fleet)
          http_request
        end
      end
    end
  end
end
