# frozen_string_literal: true

Given('I visit the manage users page') do
  mock_api
  mock_users
  login_owner
  visit users_path
end

Given('I visit the manage users page with no users') do
  mock_api
  mock_empty_users_list
  login_owner
  visit users_path
end

Given('I visit the manage users page with more then 10 users') do
  mock_api
  mock_more_then_ten_users
  login_owner
  visit users_path
end

Given('I visit the manage users page when i am on the list') do
  mock_api
  mock_user_on_list
  visit users_path
end

Then('I should be on the manage users page') do
  expect(page).to have_current_path(users_path)
end

private

def mock_empty_users_list
  allow(AccountsApi).to receive(:users).and_return([])
end

def mock_more_then_ten_users
  api_response = read_response('/manage_users/users.json')['users']
  api_response << api_response.first
  allow(AccountsApi).to receive(:users).and_return(api_response)
end

def mock_user_on_list
  user = new_user
  api_response = {
    accountUserId: user.account_id,
    name: 'Mary Smith',
    email: 'user@example.com'
  }.stringify_keys
  allow(AccountsApi).to receive(:users).and_return([api_response])
  allow_any_instance_of(User).to receive(:authentication).and_return(user)
  fill_sign_in_form
end

def mock_api
  mock_vehicles_in_fleet
  mock_debits
end
