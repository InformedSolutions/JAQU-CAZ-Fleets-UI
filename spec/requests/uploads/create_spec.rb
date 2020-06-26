# frozen_string_literal: true

require 'rails_helper'

describe 'UploadsController - #index' do
  subject { post uploads_path, params: { file: file } }

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
    subject
    expect(response).to redirect_to(processing_uploads_path)
  end

  it 'sets filename in the session' do
    subject
    expect(session[:job][:filename]).to eq(file_name)
  end

  it 'sets job name in the session' do
    subject
    expect(session[:job][:job_name]).to eq(job_name)
  end

  it 'sets correlation_id in the session' do
    subject
    expect(session[:job][:correlation_id]).to eq(correlation_id)
  end

  it 'calls UploadFile with the right params' do
    expect(UploadFile)
      .to receive(:call)
      .with(file: an_instance_of(ActionDispatch::Http::UploadedFile), user: user)
    subject
  end

  it 'triggers job the right params' do
    expect(FleetsApi)
      .to receive(:register_job)
      .with(filename: file_name, correlation_id: correlation_id)
    subject
  end

  context 'when the upload fails' do
    before do
      allow(UploadFile).to receive(:call).and_raise(CsvUploadException, alert)
    end

    let(:alert) { 'alert message' }

    it 'redirects to #index' do
      subject
      expect(response).to redirect_to(uploads_path)
    end

    it 'sets the alert' do
      subject
      expect(flash[:alert]).to eq(alert)
    end

    it 'does not trigger job' do
      expect(FleetsApi).not_to receive(:register_job)
      subject
    end
  end
end
