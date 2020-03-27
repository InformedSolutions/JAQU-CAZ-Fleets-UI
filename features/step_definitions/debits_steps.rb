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

When('I have active mandates for selected CAZ') do
  mock_api_endpoints
end

When('I have only inactive mandates for selected CAZ') do
  mock_api_endpoints('inactive_caz_mandates')
end

private

def mock_api_endpoints(caz_mandates = 'caz_mandates')
  mock_clean_air_zones
  mock_vehicles_in_fleet
  mock_debits('mandates')
  mock_caz_mandates(caz_mandates)
  mock_create_payment
end

def add_mandate(mocked_file)
  api_response = read_response("/debits/#{mocked_file}.json")['clearAirZones']
  allow(DebitsApi).to receive(:mandates).and_return(api_response)
end

def mock_debits(mocked_file = 'mandates')
  api_response = read_response("/debits/#{mocked_file}.json")['clearAirZones']
  allow(DebitsApi).to receive(:mandates).and_return(api_response)
end

def mock_caz_mandates(mocked_file)
  api_response = read_response("/debits/#{mocked_file}.json")['mandates']
  allow(DebitsApi).to receive(:caz_mandates).and_return(api_response)
end

def mock_create_payment
  api_response = read_response('/debits/create_payment.json')
  allow(DebitsApi).to receive(:create_payment).and_return(api_response)
end
