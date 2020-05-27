# frozen_string_literal: true

require 'rails_helper'

describe 'VehicleController - POST #add_to_fleet', type: :request do
  subject(:http_request) { post add_to_fleet_vehicles_path }

  context 'when user is not signed in' do
    it 'returns redirect to the login page' do
      http_request
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before do
      account_id = SecureRandom.uuid
      sign_in create_user(account_id: account_id)
    end

    context 'without VRN previously added' do
      before do
        binding.pry
        allow(FleetsApi).to receive(:add_vehicle_to_fleet).and_return(true)
        add_to_session(vrn: @vrn)
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

      it 'removes fleet_csv_uploading_process from session' do
        http_request
        expect(session[:fleet_csv_uploading_process]).to be_nil
      end

      it 'sets :success flash message' do
        http_request
        expect(flash[:success])
          .to eq("You have successfully added #{@vrn} to your vehicle list.")
      end
    end

    context 'with VRN previously added' do
      let(:message) { 'AccountVehicle already exists' }

      before do
        allow(FleetsApi)
          .to receive(:add_vehicle_to_fleet)
          .and_raise(
            BaseApi::Error422Exception.new(422, '', message: message)
          )
        add_to_session(vrn: @vrn)
        current_user.add_vehicle(vrn)
      end

      it 'removes vrn from session' do
        http_request
        expect(session[:vrn]).to be_nil
      end

      it 'removes fleet_csv_uploading_process from session' do
        http_request
        expect(session[:fleet_csv_uploading_process]).to be_nil
      end

      it 'sets :warning flash message' do
        http_request
        expect(flash[:warning])
          .to eq("#{@vrn} already exists in your vehicle list.")
      end
    end
  end
end
