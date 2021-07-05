# frozen_string_literal: true

When('I visit the edit vehicles page') do
  mock_actual_account_name
  mock_users
  mock_debits
  mock_clean_air_zones
  mock_vehicles_in_fleet
  mock_delete_single_vrn
  mock_delete_multiple_vrns

  login_user({ permissions: 'MANAGE_VEHICLES' })
  visit edit_fleets_path
end

When('I visit the edit vehicles page with last vehicle') do
  mock_actual_account_name
  mock_users
  mock_debits
  mock_clean_air_zones
  mock_delete_single_vrn
  mock_delete_multiple_vrns
  mock_last_vehicle_in_fleet

  login_user({ permissions: 'MANAGE_VEHICLES' })
  visit edit_fleets_path
end

Then('I should be on remove vehicles page') do
  expect(page).to have_current_path(remove_vehicles_fleets_path)
end

Then('I should be on confirm remove vehicle page') do
  expect(page).to have_current_path(confirm_remove_vehicle_fleets_path)
end

Then('I should be on confirm remove vehicles page') do
  expect(page).to have_current_path(confirm_remove_vehicles_fleets_path)
end

Then('I should be on vehicles to remove page') do
  expect(page).to have_current_path(vehicles_to_remove_details_fleets_path)
end

When('I select one vrn') do
  page.find('#CAZ101').click
end

When('I select two vrns') do
  page.find('#CAZ101').click
  page.find('#CAZ102').click
end

When('I press Continue button and delete my last vehicle in fleet') do
  mock_debits
  mock_empty_fleet
  click_button('Continue')
end

When('I press Remove button and delete my last vehicle in fleet') do
  mock_debits
  mock_empty_fleet
  click_link('Remove')
end
