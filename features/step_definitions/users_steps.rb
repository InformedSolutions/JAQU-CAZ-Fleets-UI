# frozen_string_literal: true

Then('I navigate to a Manage users page') do
  visit manage_users_path
end

Then('I should enter valid user details') do
  fill_in('users_name', with: 'User Name')
  fill_in('users_email_address', with: 'user@example.com')
  click_button 'Continue'
end
