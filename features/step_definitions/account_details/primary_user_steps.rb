# frozen_string_literal: true

Given('I visit primary user Account Details page') do
  mock_vehicles_in_fleet
  mock_users
  mock_debits
  mock_account_details

  login_owner
  visit non_primary_users_account_details_path
end

And('I should be on the primary user Account Details page') do
  expect(page).to have_current_path(primary_users_account_details_path)
end
