# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleController - POST #confirm_and_add_exempt_vehicle_to_fleet', type: :request do
  subject do
    post confirm_and_add_exempt_vehicle_to_fleet_vehicles_path,
         params: { 'confirm-vehicle' => confirmation }
  end

  let(:confirmation) { 'yes' }
  let(:account_id) { SecureRandom.uuid }
  let(:user) { create_user(account_id: account_id) }

  it 'returns redirect to the login page' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is signed in' do
    before { sign_in user }

    context 'without VRN in the session' do
      it 'returns redirect to vehicles#enter_details' do
        subject
        expect(response).to redirect_to(enter_details_vehicles_path)
      end
    end

    context 'with VRN in the session' do
      before do
        allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
        add_to_session(vrn: @vrn)
      end

      context 'when user does not confirm details' do
        let(:confirmation) { 'no' }

        it 'redirects to incorrect details page' do
          subject
          expect(response).to redirect_to(incorrect_details_vehicles_path)
        end
      end

      context 'when confirmation is empty' do
        let(:confirmation) { '' }

        it 'redirects to confirm details page' do
          subject
          expect(response).to redirect_to(details_vehicles_path)
        end
      end

      context 'when user confirms details' do
        context 'without VRN previously added' do
          before do
            allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
            add_to_session(vrn: @vrn)
            subject
          end

          it 'adds the vehicle to the fleet' do
            expect(FleetsApi).to have_received(:add_vehicle_to_fleet)
              .with(vrn: @vrn, account_id: account_id)
          end

          it 'removes vrn from session' do
            expect(session[:vrn]).to be_nil
          end

          it 'removes show_continue_button from session' do
            expect(session[:show_continue_button]).to be_nil
          end

          it 'sets :success flash message' do
            expect(flash[:success]).to eq("You have successfully added #{@vrn} to your vehicle list.")
          end

          it 'redirects to local vehicle exemptions' do
            expect(response).to redirect_to(fleets_path)
          end
        end

        context 'with VRN previously added' do
          let(:message) { 'AccountVehicle already exists' }

          before do
            allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_raise(
              BaseApi::Error422Exception.new(422, '', message: message)
            )
            add_to_session(vrn: @vrn)
            user.add_vehicle(@vrn)
            subject
          end

          it 'removes vrn from session' do
            expect(session[:vrn]).to be_nil
          end

          it 'removes show_continue_button from session' do
            expect(session[:show_continue_button]).to be_nil
          end

          it 'sets :warning flash message' do
            expect(flash[:warning]).to eq("#{@vrn} already exists in your vehicle list.")
          end
        end
      end
    end
  end
end
