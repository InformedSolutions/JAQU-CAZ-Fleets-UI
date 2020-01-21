# frozen_string_literal: true

When('I visit the upload page') do
  login_user
  visit uploads_path
end

When('I attach a file') do
  attach_file(:file, File.join('spec', 'fixtures', 'uploads', 'fleet.csv'))

  allow(UploadFile).to receive(:call).and_return('filename')
end

When('I press upload') do
  click_button 'Upload'
end

Then('I should be on the processing page') do
  expect_path(processing_uploads_path)
end

Then('I should download the template') do
  expect(page.response_headers['Content-Type']).to eq('text/csv')
  expect(page.response_headers['Content-Disposition']).to include('VehicleUploadTemplate.csv')
end
