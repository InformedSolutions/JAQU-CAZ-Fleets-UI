# frozen_string_literal: true

When('I navigate to a Dashboard page') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
  visit dashboard_path
end

When('I navigate to a Dashboard page with empty fleets') do
  mock_empty_fleet
  mock_debits('inactive_mandates')
  visit dashboard_path
end
