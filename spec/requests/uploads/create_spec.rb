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

  before do
    allow(UploadFile).to receive(:call).and_return(file_name)
    sign_in user
  end

  it 'redirects to #processing' do
    http_request
    expect(response).to redirect_to(processing_uploads_path)
  end

  it 'sets filename in the session' do
    http_request
    expect(session[:file_name]).to eq(file_name)
  end

  it 'calls UploadFile with the right params' do
    expect(UploadFile)
      .to receive(:call)
      .with(file: an_instance_of(ActionDispatch::Http::UploadedFile), user: user)
    http_request
  end

  context 'when the upload fails' do
    before do
      allow(UploadFile).to receive(:call).and_raise(CsvUploadException, alert)
      http_request
    end

    let(:alert) { 'alert message' }

    it 'redirects to #index' do
      expect(response).to redirect_to(uploads_path)
    end

    it 'sets the alert' do
      expect(flash[:alert]).to eq(alert)
    end
  end
end
