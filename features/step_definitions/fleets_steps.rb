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
  expect(page).to have_current_path(uploads_path)
end

When('I have vehicles in my fleet') do
  mock_clean_air_zones
  mock_vehicles_in_fleet
end

Then('I should be on the manage vehicles page') do
  expect(page).to have_current_path(fleets_path)
end

Then('I should be on the delete vehicle page') do
  expect(page).to have_current_path(delete_fleets_path)
end

Then('I should have deleted the vehicle') do
  expect(@fleet).to have_received(:delete_vehicle)
end

When('Fleet backend API is unavailable') do
  mock_unavailable_fleet
end

Then('I should see active {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).to eq('active')
end

Then('I should see inactive {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).to be_nil
end

Then('I should not see {string} pagination button') do |text|
  expect(page).not_to have_selector("#pagination-button-#{text}")
end

When('I press {int} pagination button') do |selected_page|
  mock_vehicles_in_fleet(selected_page)
  page.find("#pagination-button-#{selected_page}").click
end
