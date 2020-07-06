# frozen_string_literal: true

When('I visit the Dashboard page') do
  visit dashboard_path
end

When('I navigate to a Dashboard page') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  visit dashboard_path
end

When('I navigate to a Dashboard page with {string} permission') do |permission|
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  login_user([permission])
end

When('I navigate to a Dashboard page with all permissions assigned') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  login_user(%w[MANAGE_VEHICLES MANAGE_MANDATES MANAGE_USERS MAKE_PAYMENTS])
end

Given('I visit Dashboard page without any users yet') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_empty_users_list
  login_user(['MANAGE_USERS'])
end

Given('I visit Dashboard page with few users already added') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  mock_users
  login_user(['MANAGE_USERS'])
end

When('I navigate to a Dashboard page with empty fleets') do
  mock_empty_fleet
  mock_debits('inactive_mandates')
  mock_users
  visit dashboard_path
end

When('I navigate to a Dashboard page with one vehicle in the fleet') do
  mock_one_vehicle_fleet
  mock_debits('inactive_mandates')
  mock_users
  visit dashboard_path
end
