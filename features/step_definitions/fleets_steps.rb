# frozen_string_literal: true

When('I have no vehicles in my fleet') do
  mock_empty_fleet
  mock_debits
end

When('I have one vehicle in my fleet') do
  mock_one_vehicle_fleet
  mock_debits
end

When('I visit the manage vehicles page') do
  login_user
  visit fleets_path
end

When('I visit the submission method page') do
  mock_vehicles_in_fleet
  mock_debits
  login_user
  visit submission_method_fleets_path
end

Then('I should be on the submission method page') do
  expect(page).to have_current_path(submission_method_fleets_path)
end

When('I select manual entry') do
  choose('Individual')
end

When('I select Bulk upload') do
  choose('File upload')
end

Then('I should be on the upload page') do
  expect(page).to have_current_path(uploads_path)
end

When('I have vehicles in my fleet') do
  mock_debits
  mock_clean_air_zones
  mock_vehicles_in_fleet
end

When('I have vehicles in my fleet that are not paid') do
  mock_clean_air_zones
  mock_unpaid_vehicles_in_fleet
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
  expect(button[:class]).to include('moj-pagination__item--active')
end

Then('I should see inactive {string} pagination button') do |text|
  button = page.find("#pagination-button-#{text}")
  expect(button[:class]).not_to include('moj-pagination__item--active')
end

Then('I should not see {string} pagination button') do |text|
  expect(page).not_to have_selector("#pagination-button-#{text}")
end

When('I press {int} pagination button') do |selected_page|
  mock_vehicles_in_fleet(selected_page)
  page.find("#pagination-button-#{selected_page}").first('a').click
end
