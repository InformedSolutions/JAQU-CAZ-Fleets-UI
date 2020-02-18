# frozen_string_literal: true

require 'rails_helper'

describe 'UploadsController - #processing' do
  subject(:http_request) { get processing_uploads_path }

  before { sign_in create_user }

  it 'redirects to uploads' do
    http_request
    expect(response).to redirect_to(uploads_path)
  end

  context 'with filename in the session' do
    let(:filename) { 'filename' }
    let(:job_name) { 'job_name' }
    let(:correlation_id) { SecureRandom.uuid }
    let(:status) { 'success' }
    let(:errors) { [] }

    before do
      add_to_session(job: {
                       filename: filename,
                       job_name: job_name,
                       correlation_id: correlation_id
                     })
      allow(FleetsApi)
        .to receive(:job_status)
        .and_return(status: status, errors: errors)
    end

    it 'calls FleetsApi.job_status with proper params' do
      expect(FleetsApi)
        .to receive(:job_status)
        .with(job_name: job_name, correlation_id: correlation_id)
      http_request
    end

    describe 'job status' do
      before do
        mock_fleet(create_empty_fleet)
        http_request
      end

      describe 'success' do
        it 'returns redirect to fleets_path' do
          expect(response).to redirect_to(fleets_path)
        end

        it 'clears job data' do
          expect(session[:job]).to be_nil
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

        it 'does not clear job data' do
          expect(session[:job]).not_to be_nil
        end
      end

      describe 'failure' do
        let(:status) { 'failure' }
        let(:errors) { ['Some error'] }

        it 'renders uploads index' do
          expect(response).to render_template('uploads/index')
        end

        it 'clears job data' do
          expect(session[:job]).to be_nil
        end

        it 'assigns errors' do
          expect(assigns[:job_errors]).to eq(errors)
        end
      end
    end
  end
end
