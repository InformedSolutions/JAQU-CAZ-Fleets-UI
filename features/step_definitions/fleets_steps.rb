# frozen_string_literal: true

When('I have no vehicles in my fleet') do
  mock_empty_fleet
end

When('I visit the manage vehicles page') do
  login_user
  visit fleets_path
end

When('I visit the the submission method page') do
  login_user
  visit submission_method_fleets_path
end

Then('I should be on the submission method page') do
  expect(page).to have_current_path(submission_method_fleets_path)
end

When('I select manual entry') do
  choose('Manual entry')
end

Then('I should be on the enter details page') do
  expect(page).to have_current_path(enter_details_fleets_path)
end

When('I select CSV upload') do
  choose('CSV upload')
end

Then('I should be on the upload page') do
  expect(page).to have_current_path(upload_fleets_path)
end
