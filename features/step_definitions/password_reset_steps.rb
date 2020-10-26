# frozen_string_literal: true

Then("I am taken to the 'Sign In' page") do
  expect_path(new_users_session_path)
end

When('I enter valid email address') do
  email = 'example@email.com'
  allow(AccountsApi)
    .to receive(:initiate_password_reset)
    .with(email: email, reset_url: passwords_url)
    .and_return(true)
  fill_in('passwords[email_address]', with: email)
  click_button 'Send email'
end

When('I click Send email button') do
  click_button 'Send email'
end

Then('I should be on the email sent page') do
  expect_path(email_sent_passwords_path)
end

When('I visit passwords without the token') do
  visit passwords_path
end

Then('I should be on the invalid page') do
  expect_path(invalid_passwords_path)
end

When('I visit passwords') do
  token = SecureRandom.uuid
  allow(AccountsApi).to receive(:validate_password_reset).with(token: token).and_return(true)
  visit passwords_path(token: token)
end

When('I enter only password') do
  fill_in('passwords[password]', with: 'password')
  click_button 'Update password'
end

When('I enter not matching password and confirmation') do
  fill_in('passwords[password]', with: 'password')
  fill_in('passwords[password_confirmation]', with: 'different_password')
  click_button 'Update password'
end

When('I enter valid password and confirmation') do
  fill_in_passwords
  token = find('#token', visible: false).value
  allow(AccountsApi)
    .to receive(:set_password)
    .with(token: token, password: 'password')
    .and_return(true)
  click_button 'Update password'
end

Then('I should be on the success page') do
  expect_path(success_passwords_path)
end

When('I enter too easy password and confirmation') do
  fill_in_passwords
  allow(AccountsApi)
    .to receive(:set_password)
    .and_raise(BaseApi::Error422Exception.new(422, '', 'errorCode' => 'passwordNotValid'))
  click_button 'Update password'
end

When('I try to reuse old password') do
  fill_in_passwords
  allow(AccountsApi)
    .to receive(:set_password)
    .and_raise(BaseApi::Error422Exception.new(422, '', 'errorCode' => 'newPasswordReuse'))
  click_button 'Update password'
end

def fill_in_passwords
  fill_in('passwords[password]', with: 'password')
  fill_in('passwords[password_confirmation]', with: 'password')
end
