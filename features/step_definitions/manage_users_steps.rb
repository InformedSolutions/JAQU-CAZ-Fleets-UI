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

Given('I visit the Add user page') do
  mock_api
  mock_users
  login_owner
  visit new_user_path
end

Then('I should be on the manage users page with some users already added') do
  mock_api
  mock_user_on_list
  expect(page).to have_current_path(users_path)
end

Then('I should be on the manage users page') do
  expect(page).to have_current_path(users_path)
end

Then('I should be on the Add user page') do
  expect(page).to have_current_path(new_user_path)
end

Then('I should be on the Add user permissions page') do
  expect(page).to have_current_path(add_permissions_users_path)
end

Then('I should be on the User confirmation page') do
  expect(page).to have_current_path(confirmation_users_path)
end

When('I fill new user form with allready used email') do
  stub = instance_double(
    'AddNewUserForm',
    valid?: false,
    email_unique?: false,
    errors: instance_double('messages', messages: { email: ['Email address already exists'] })
  )
  allow(AddNewUserForm).to receive(:new).and_return(stub)

  fill_in('new_user_name', with: 'User Name')
  click_button 'Continue'
end

When('I fill new user form with correct data') do
  stub = instance_double('AddNewUserForm', valid?: true)
  allow(AddNewUserForm).to receive(:new).and_return(stub)

  fill_in('new_user_name', with: 'New User Name')
  fill_in('new_user_email', with: 'new_user@example.com')

  click_button 'Continue'
end

When('I press {string} button and new user email is still unique') do |_string|
  stub = instance_double(
    'AddNewUserPermissionsForm',
    valid?: false,
    email_unique?: true,
    errors: instance_double(
      'messages',
      messages: {
        permissions: ['Select at least one permission type to continue'],
        email: []
      }
    )
  )
  allow(AddNewUserPermissionsForm).to receive(:new).and_return(stub)

  click_button 'Continue'
end

When('I checked permissions correctly') do
  stub = instance_double('AddNewUserPermissionsForm', valid?: true, submit: true)
  allow(AddNewUserPermissionsForm).to receive(:new).and_return(stub)

  check('manage-vehicles-permission')

  click_button 'Continue'
end

When('I press {string} button and new user with email was added in the meantime') do |_string|
  stub = instance_double(
    'AddNewUserPermissionsForm',
    valid?: false,
    email_unique?: false,
    errors: instance_double('messages', messages: { email: ['Email address already exists'] })
  )
  allow(AddNewUserPermissionsForm).to receive(:new).and_return(stub)

  click_button 'Continue'
end

private

def mock_api
  mock_vehicles_in_fleet
  mock_debits
end
