# frozen_string_literal: true

When('I visit the Dashboard page') do
  visit dashboard_path
end

When('I navigate to a Dashboard page') do
  mock_direct_debit_enabled
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  visit dashboard_path
end

When('I navigate to a Dashboard page with Direct Debits disabled') do
  mock_direct_debit_disabled
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  visit dashboard_path
end

When('I navigate to a Dashboard page with Direct Debits enabled') do
  allow(Rails.application.config.x).to receive(:method_missing).and_return('test')
  allow(Rails.application.config.x).to receive(:method_missing).with(:feature_direct_debits).and_return(false)
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  visit dashboard_path
end

When('I navigate to a Dashboard page without any payers users') do
  mock_empty_users_list
  visit dashboard_path
end

When('I navigate to a Dashboard page with {string} permission') do |permission|
  mock_direct_debit_enabled
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  login_user(permissions: [permission])
end

When('I navigate to a Dashboard page with all permissions assigned') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  login_owner
end

Given('I visit Dashboard page without any users yet') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_empty_users_list
  login_owner
end

Given('I visit Dashboard page with few users already added') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  login_owner
end

When('I navigate to a Dashboard page with empty fleets') do
  mock_direct_debit_enabled
  mock_empty_fleet
  mock_debits('inactive_mandates')
  mock_users
  visit dashboard_path
end

When('I navigate to a Dashboard page with one vehicle in the fleet') do
  mock_direct_debit_enabled
  mock_one_vehicle_fleet
  mock_debits('inactive_mandates')
  mock_users
  visit dashboard_path
end

And('I should be on the Dashboard page') do
  expect(page).to have_current_path(dashboard_path)
end
