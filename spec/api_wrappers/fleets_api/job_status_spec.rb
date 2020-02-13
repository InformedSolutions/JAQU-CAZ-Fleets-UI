# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsApi.job_status' do
  subject(:call) { FleetsApi.job_status(job_name: job_name, correlation_id: id) }
  let(:url) { %r{accounts/register-csv-from-s3/jobs/#{job_name}} }
  let(:id) { SecureRandom.uuid }
  let(:job_name) { SecureRandom.uuid }
  let(:status) { 'SUCCESS' }
  let(:errors) { ['Invalid VRN'] }

  context 'when the response status is 200' do
    before do
      stub_request(:get, url)
        .to_return(status: 200, body: { 'status' => status, 'errors' => errors }.to_json)
    end

    it 'calls API with correlation ID in headers' do
      call
      expect(WebMock).to(
        have_requested(:get, url).with { |req| req.headers['X-Correlation-Id'] == id }.once
      )
    end

    it 'returns job status' do
      expect(call[:status]).to eq(status)
    end

    it 'returns job errors' do
      expect(call[:errors]).to eq(errors)
    end
  end

  context 'when the response status is 500' do
    before do
      stub_request(:get, url).to_return(
        status: 500,
        body: { 'message' => 'Internal error' }.to_json
      )
    end

    it 'raises Error500Exception' do
      expect { call }.to raise_exception(BaseApi::Error500Exception)
    end
  end
end
