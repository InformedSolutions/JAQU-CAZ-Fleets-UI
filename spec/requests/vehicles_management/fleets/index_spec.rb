# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::FleetsController - GET #index' do
  subject { get fleets_path }

  context 'correct permissions' do
    before { sign_in user }

    let(:user) { manage_vehicles_user }

    context 'with empty fleet' do
      before { mock_fleet(create_empty_fleet) }

      it 'redirects to  #submission_method' do
        subject
        expect(response).to redirect_to submission_method_fleets_path
      end
    end

    context 'with vehicles in fleet' do
      before { mock_caz_list }

      context 'and without upload data in redis' do
        before do
          mock_fleet
          subject
        end

        it 'renders manage vehicles page' do
          expect(response).to render_template('fleets/index')
        end

        it 'sets default page value to 1' do
          expect(assigns(:pagination).page).to eq(1)
        end

        it 'not sets :success flash message' do
          expect(flash[:success]).to be_nil
        end
      end

      context 'with upload data in redis' do
        before do
          account = "account_id_#{user.account_id}"
          REDIS.hmset(account, 'job_id', SecureRandom.uuid, 'correlation_id', SecureRandom.uuid)
          allow(FleetsApi).to receive(:job_status).and_return(status: status, errors: [])
          mock_fleet
          subject
        end

        context 'and when status is SUCCESS' do
          let(:status) { 'SUCCESS' }

          it 'renders manage vehicles page' do
            expect(response).to render_template('fleets/index')
          end

          it 'sets :success flash message' do
            expect(flash[:success]).to eq('You have successfully uploaded 45 vehicles to your vehicle list.')
          end
        end

        context 'and when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
          let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }

          it 'redirects to calculating chargeability page' do
            expect(response).to redirect_to(calculating_chargeability_uploads_path)
          end

          it 'not sets :success flash message' do
            expect(flash[:success]).to be_nil
          end
        end
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
