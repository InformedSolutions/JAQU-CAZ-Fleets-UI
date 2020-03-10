# frozen_string_literal: true

When('I navigate to a Dashboard page') do
  mock_vehicles_in_fleet
  visit dashboard_path
end

When('I navigate to a Dashboard page with empty fleets') do
  mock_empty_fleet
  visit dashboard_path
end
