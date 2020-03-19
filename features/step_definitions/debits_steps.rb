# frozen_string_literal: true

When('I have no mandates') do
  mock_vehicles_in_fleet
  mock_debits('inactive_mandates')
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
  mock_debits
end

When('I have created all the possible mandates') do
  mock_vehicles_in_fleet
  mock_debits('active_mandates')
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
  mock_debits
  allow(DebitsApi).to receive(:add_mandate).and_return(true)
end

private

def mock_debits(mocked_file = 'mandates')
  api_response = read_response("/debits/#{mocked_file}.json")['clearAirZones']
  allow(DebitsApi).to receive(:direct_debit_mandates).and_return(api_response)
end
