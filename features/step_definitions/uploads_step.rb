# frozen_string_literal: true

When('I visit the upload page') do
  login_user
  visit uploads_path
end

When('I attach a file') do
  attach_file(:file, File.join('spec', 'fixtures', 'uploads', 'fleet.csv'))

  allow(UploadFile).to receive(:call).and_return('filename')
  allow(FleetsApi).to receive(:register_job).and_return('job_name')
end

When('I press upload') do
  allow(FleetsApi).to receive(:job_status).and_return(status: 'running')
  click_button 'Upload'
end

Then('I should be on the processing page') do
  expect_path(processing_uploads_path)
end

# rubocop:disable Layout/LineLength
Then('I should be on the local vehicles exemptions page with continue_path redirecting to processing page') do
  expect_path(local_exemptions_vehicles_path(continue_path: processing_uploads_path))
end
# rubocop:enable Layout/LineLength

Then('I should download the template') do
  expect(page.response_headers['Content-Type']).to eq('text/csv')
  expect(page.response_headers['Content-Disposition']).to include('VehicleUploadTemplate.csv')
end

When('I am on the processing page') do
  mock_vehicles_in_fleet
  mock_debits
  login_user
  page.set_rack_session(
    job: { job_name: SecureRandom.uuid, correlation_id: SecureRandom.uuid }
  )
  allow(FleetsApi).to receive(:job_status).and_return(status: 'running')
  visit processing_uploads_path
end

When('My upload is successful') do
  allow(FleetsApi).to receive(:job_status).and_return(status: 'success')
  mock_clean_air_zones
  mock_vehicles_in_fleet
end

When('My upload is failed with error: {string}') do |error|
  allow(FleetsApi)
    .to receive(:job_status)
    .and_return(status: 'failure', errors: [error])
  mock_clean_air_zones
  mock_empty_fleet
end
