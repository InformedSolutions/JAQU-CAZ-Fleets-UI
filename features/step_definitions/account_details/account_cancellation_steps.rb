# frozen_string_literal: true

When('I visit account cancellation page') do
  mock_chargeable_vehicles
  mock_vehicles_in_fleet
  mock_users
  mock_debits
  mock_account_details
  mock_clean_air_zones
  mock_account_cancellation

  login_owner

  visit account_cancellation_path
end

Then('I should be redirected to Account Closed page') do
  expect(page).to have_current_path(account_closed_path)
end
