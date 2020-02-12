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

    before do
      add_to_session(job: {
                       filename: filename,
                       job_name: job_name,
                       correlation_id: correlation_id
                     })
      http_request
    end

    it 'is successful' do
      expect(response).to have_http_status(:success)
    end

    it 'renders processing' do
      expect(response).to render_template('uploads/processing')
    end
  end
end
