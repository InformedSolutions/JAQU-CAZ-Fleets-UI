# frozen_string_literal: true

Given('I am on the Sign in page') do
  visit new_user_session_path
end

Then('I should enter valid credentials and press the Continue') do
  sign_in_user
end

Then('I should enter fleet admin credentials and press the Continue') do
  sign_in_user(password: 'admin_password')
end

def sign_in_user(password: 'password')
  visit new_user_session_path
  fill_in('user_email', with: 'user@example.com')
  fill_in('user_password', with: password)
  click_button 'Continue'
end

When('I have no authentication cookie') do
  cookie = get_me_the_cookie('_caz-fleets_session')
  expect(cookie).to be_nil
end

And('Cookie is created for my session') do
  cookie = get_me_the_cookie('_caz-fleets_session')
  expect(cookie).to_not be_nil
end

When('I have authentication cookie that has not expired') do
  visit new_user_session_path
  sign_in_user

  cookie = get_me_the_cookie('_caz-fleets_session')
  expect(cookie).to_not be_nil
  expect(cookie[:expires] > Time.current).to be true
end

Then('I am redirected to the Sign in page') do
  expect(page).to have_current_path(root_path)
end

Then('I am redirected to the unauthenticated root page') do
  expect(page).to have_current_path(new_user_session_path)
end

When('I enter invalid credentials') do
  fill_in('user_email', with: 'user@example.com')
  fill_in('user_password', with: '1234')
  click_button 'Continue'
end

Then('I remain on the current page') do
  expect(page).to have_current_path(new_user_session_path)
end

Given('I have authentication cookie that has expired') do
  # set default session_timeout
  Rails.configuration.x.session_timeout = 15

  travel_to(20.minutes.ago) do
    sign_in_user
  end

  cookie = get_me_the_cookie('_caz-fleets_session')
  expect(cookie).to_not be_nil
  expect(cookie[:expires] < Time.current).to be true
end

Given('I am signed in') do
  sign_in_user
end

When('I request to sign out') do
  click_link 'Sign Out'
end

When('I enter invalid email format') do
  fill_in('user_email', with: 'user.example.com')
  fill_in('user_password', with: '12345678')

  click_button 'Continue'
end
