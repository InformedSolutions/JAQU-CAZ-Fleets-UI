# frozen_string_literal: true

When('I have no mandates') do
  mock_vehicles_in_fleet
  mock_debit(create_empty_debit)
end

When('I visit the manage direct debit page') do
  login_user
  visit debits_path
end

Then('I should be on the add new mandate page') do
  expect_path(new_debit_path)
end

When('I have created mandates') do
  mock_vehicles_in_fleet
  mock_debit(create_debit(zones: mocked_zones))
end

When('I have created all the possible mandates') do
  mock_vehicles_in_fleet
  mock_debit(create_debit(zones: []))
end

Then('I should be on the manage debits page') do
  expect_path(debits_path)
end

When('I visit the add new mandate page') do
  login_user
  visit new_debit_path
end

When('I select Birmingham') do
  choose('Birmingham')
end

Then('I should have a new mandate added') do
  expect(@debit).to have_received(:add_mandate)
end
