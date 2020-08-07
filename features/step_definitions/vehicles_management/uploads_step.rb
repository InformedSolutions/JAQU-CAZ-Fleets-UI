# frozen_string_literal: true

When('I visit the upload page') do
  login_user(permissions: ['MANAGE_VEHICLES'])
  visit uploads_path
end

When('I attach a file') do
  attach_valid_csv_file
  allow(VehiclesManagement::UploadFile).to receive(:call).and_return('filename')
  allow(FleetsApi).to receive(:register_job).and_return('job_name')
end

When('I press Upload file button') do
  allow(FleetsApi).to receive(:job_status).and_return(status: 'running')
  click_button 'Upload file'
end

Then('I should be on the processing page') do
  expect_path(processing_uploads_path)
end

Then('I should download the template') do
  expect(page.response_headers['Content-Type']).to eq('text/csv')
  expect(page.response_headers['Content-Disposition']).to include('VehicleUploadTemplate.csv')
end

When('I am on the processing page') do
  mock_vehicles_in_fleet
  login_user(permissions: 'MANAGE_VEHICLES')
  page.set_rack_session(job: { job_name: SecureRandom.uuid, correlation_id: SecureRandom.uuid })
  allow(FleetsApi).to receive(:job_status).and_return(status: 'running')
  visit processing_uploads_path
end

When('My upload is successful') do
  allow(FleetsApi).to receive(:job_status).and_return(status: 'success')
  mock_clean_air_zones
  mock_vehicles_in_fleet
end

When('My upload is failed with error: {string}') do |error|
  allow(FleetsApi).to receive(:job_status).and_return(status: 'failure', errors: [error])
  mock_clean_air_zones
  mock_empty_fleet
end

When('I upload a csv file whose size is too big') do
  attach_valid_csv_file
  allow_any_instance_of(ActionDispatch::Http::UploadedFile).to receive(:size).and_return(52_428_801)
  click_button 'Upload file'
end

private

def attach_valid_csv_file
  attach_file(:file, File.join('spec', 'fixtures', 'uploads', 'fleet.csv'))
end
