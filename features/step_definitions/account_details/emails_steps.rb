# frozen_string_literal: true

And('I enter change my email page') do
  mock_user_details
  visit edit_email_primary_users_path
end

Then('I should be on account details update email page') do
  expect(page).to have_current_path(edit_email_primary_users_path)
end

And('I fill in email with empty string') do
  fill_in('primary_user_email', with: '')
end

And('I fill in email with email with invalid format') do
  mock_successful_user_validation
  fill_in('primary_user_email', with: 'invalid-email')
end

When('I fill in email with email with already taken email') do
  mock_failed_user_validation
  fill_in('primary_user_email', with: 'valid@email.com')
end

When('I fill in email with valid email address') do
  mock_successful_user_validation
  fill_in('primary_user_email', with: 'valid@email.com')
  mock_owners_change_email
end

Then('I should be on the verification email sent page') do
  expect(page).to have_current_path(email_sent_primary_users_path)
end

When('I visit the Confirm email update page') do
  mock_vehicles_in_fleet
  mock_users
  mock_direct_debit_disabled
  mock_account_details
  allow(AccountsApi::Auth).to receive(:confirm_email).and_return(true)

  login_owner
  visit confirm_email_primary_users_path(token: SecureRandom.uuid)
end

When('I enter too easy password and confirmation password') do
  fill_in_passwords
  allow(AccountsApi::Auth)
    .to receive(:confirm_email)
    .and_raise(BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid'))
end

When('I enter reused old password') do
  fill_in_passwords
  allow(AccountsApi::Auth)
    .to receive(:confirm_email)
    .and_raise(BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse'))
end
