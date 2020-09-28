# frozen_string_literal: true

Given('I visit primary user Account Details page') do
  mock_vehicles_in_fleet
  mock_users

  login_owner
  mock_user_details
  mock_account_details

  visit non_primary_users_account_details_path
end

And('I should be on the primary user Account Details page') do
  expect(page).to have_current_path(primary_users_account_details_path)
end

