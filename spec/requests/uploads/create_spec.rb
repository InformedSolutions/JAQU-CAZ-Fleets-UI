# frozen_string_literal: true

require 'rails_helper'

describe 'UploadsController - #index' do
  subject(:http_request) { post uploads_path, params: { file: file } }

  let(:file_path) do
    File.join('spec', 'fixtures', 'uploads', 'fleet.csv')
  end
  let(:file) { fixture_file_upload(file_path) }
  let(:user) { create_user }
  let(:file_name) { 'filename' }
  let(:job_name) { 'job_name' }
  let(:correlation_id) { SecureRandom.uuid }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(correlation_id)
    allow(UploadFile).to receive(:call).and_return(file_name)
    allow(FleetsApi).to receive(:register_job).and_return(job_name)
    sign_in user
  end

  it 'redirects to #processing' do
    http_request
    continue_path = local_exemptions_vehicles_path(continue_path: processing_uploads_path)
    expect(response).to redirect_to(continue_path)
  end

  it 'sets filename in the session' do
    http_request
    expect(session[:job][:filename]).to eq(file_name)
  end

  it 'sets job name in the session' do
    http_request
    expect(session[:job][:job_name]).to eq(job_name)
  end

  it 'sets correlation_id in the session' do
    http_request
    expect(session[:job][:correlation_id]).to eq(correlation_id)
  end

  it 'calls UploadFile with the right params' do
    expect(UploadFile)
      .to receive(:call)
      .with(file: an_instance_of(ActionDispatch::Http::UploadedFile), user: user)
    http_request
  end

  it 'triggers job the right params' do
    expect(FleetsApi)
      .to receive(:register_job)
      .with(filename: file_name, correlation_id: correlation_id)
    http_request
  end

  context 'when the upload fails' do
    before do
      allow(UploadFile).to receive(:call).and_raise(CsvUploadException, alert)
    end

    let(:alert) { 'alert message' }

    it 'redirects to #index' do
      http_request
      expect(response).to redirect_to(uploads_path)
    end

    it 'sets the alert' do
      http_request
      expect(flash[:alert]).to eq(alert)
    end

    it 'does not trigger job' do
      expect(FleetsApi).not_to receive(:register_job)
      http_request
    end
  end
end
