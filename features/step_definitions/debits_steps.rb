# frozen_string_literal: true

When('I have no mandates') do
  mock_vehicles_in_fleet
  mock_debits_api_call('inactive_mandates')
end

When('I visit the manage Direct Debit page') do
  login_user
  visit debits_path
end

Then('I visit the payment method page') do
  visit select_payment_method_payments_path
end

Then('I should be on the add new mandate page') do
  expect_path(new_debit_path)
end

When('I have created mandates') do
  mock_vehicles_in_fleet
  mock_debits_api_call
end

When('I have created all the possible mandates') do
  mock_vehicles_in_fleet
  mock_debits_api_call('active_mandates')
end

Then('I should be on the manage debits page') do
  expect_path(debits_path)
end

When('I visit the add new mandate page') do
  login_user
  visit new_debit_path
end

Then('I press `Set up new Direct Debit` button') do
  mock_debits_api_call('inactive_mandates')
  click_button 'Set up new Direct Debit'
end

Then('I should have a new mandate added') do
  mock_debits_api_call
  allow(DebitsApi).to receive(:create_mandate).and_return(true)
end

When('I have active mandates for selected CAZ') do
  mock_api_endpoints
end
