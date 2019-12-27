# frozen_string_literal: true

When('I have no vehicles in my fleet') do
  mock_empty_fleet
end

When('I visit the manage vehicles page') do
  login_user
  visit fleets_path
end

When('I visit the submission method page') do
  login_user
  visit submission_method_fleets_path
end

Then('I should be on the submission method page') do
  expect(page).to have_current_path(submission_method_fleets_path)
end

When('I select manual entry') do
  choose('Manual entry')
end

When('I select CSV upload') do
  choose('CSV upload')
end

Then('I should be on the upload page') do
  expect(page).to have_current_path(upload_fleets_path)
end

When('I have vehicles in my fleet') do
  mock_vehicles_in_fleet
end

Then('I should be on the manage vehicles page') do
  expect(page).to have_current_path(fleets_path)
end
