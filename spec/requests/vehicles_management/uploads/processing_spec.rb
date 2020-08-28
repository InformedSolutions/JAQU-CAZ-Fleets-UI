# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesManagement::UploadsController - GET #processing' do
  subject { get processing_uploads_path }

  context 'correct permissions' do
    before { sign_in user }

    let(:user) { manage_vehicles_user }

    it 'redirects to uploads' do
      subject
      expect(response).to redirect_to(uploads_path)
    end

    context 'with filename in the session' do
      let(:filename) { 'filename' }
      let(:job_id) { SecureRandom.uuid }
      let(:correlation_id) { SecureRandom.uuid }
      let(:status) { 'CHARGEABILITY_CALCULATION_IN_PROGRESS' }
      let(:errors) { [] }

      before do
        account = "account_id_#{user.account_id}"
        REDIS.hmset(account, 'job_id', job_id, 'correlation_id', correlation_id)
        allow(FleetsApi).to receive(:job_status).and_return(status: status, errors: errors)
        mock_fleet(create_empty_fleet)
      end

      it 'calls FleetsApi.job_status with proper params' do
        expect(FleetsApi).to receive(:job_status).with(job_id: job_id, correlation_id: correlation_id)
        subject
      end

      describe 'job status' do
        before do
          mock_fleet(create_fleet)
          subject
        end

        context 'when status is CHARGEABILITY_CALCULATION_IN_PROGRESS' do
          it 'redirects to local exemptions page' do
            expect(response).to redirect_to(local_exemptions_vehicles_path)
          end

          it 'not sets :success flash message' do
            expect(flash[:success]).to be_nil
          end
        end

        context 'when status is FINISHED_' do
          let(:status) { 'FINISHED_' }

          it 'redirects to local exemptions page' do
            expect(response).to redirect_to(local_exemptions_vehicles_path)
          end

          it 'sets :success flash message' do
            expect(flash[:success]).to eq('You have successfully uploaded 45 vehicles to your vehicle list.')
          end
        end

        context 'when status is FINISHED_WITH_ERRORS' do
          let(:status) { 'FINISHED_WITH_ERRORS' }

          it 'redirects to local exemptions page' do
            expect(response).to redirect_to(local_exemptions_vehicles_path)
          end
        end

        describe 'running' do
          let(:status) { 'running' }

          it 'is successful' do
            expect(response).to have_http_status(:success)
          end

          it 'renders processing' do
            expect(response).to render_template('uploads/processing')
          end
        end

        describe 'failure' do
          let(:status) { 'failure' }
          let(:errors) { ['Some error'] }

          it 'renders the upload page' do
            expect(response).to render_template('uploads/index')
          end

          it 'assigns errors' do
            expect(assigns[:job_errors]).to eq(errors)
          end
        end
      end
    end
  end

  it_behaves_like 'incorrect permissions'
end
