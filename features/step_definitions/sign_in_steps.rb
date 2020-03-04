# frozen_string_literal: true

Given('I am on the Sign in page') do
  visit new_user_session_path
end

Then('I should enter valid credentials and press the Continue') do
  login_user
end

Then('I should enter fleet admin credentials and press the Continue') do
  login_admin
end

When('I have no authentication cookie') do
  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to be_nil
end

And('Cookie is created for my session') do
  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to_not be_nil
end

When('I have authentication cookie that has not expired') do
  visit new_user_session_path
  login_user

  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to_not be_nil
  expect(cookie[:expires] > Time.current).to be true
end

Then('I am redirected to the Sign in page') do
  expect(page).to have_current_path(root_path)
end

Then('I am redirected to the Sign out page') do
  expect(page).to have_current_path(sign_out_path)
end

Then('I am redirected to the unauthenticated root page') do
  expect(page).to have_current_path(new_user_session_path)
end

When('I enter invalid credentials') do
  allow(AccountsApi)
    .to receive(:sign_in)
    .and_raise(BaseApi::Error401Exception.new(401, '', {}))
  fill_sign_in_form
end

When('I enter unconfirmed email') do
  allow(AccountsApi)
    .to receive(:sign_in)
    .and_raise(BaseApi::Error422Exception.new(422, '', {}))
  fill_sign_in_form
end

Then('I remain on the current page') do
  expect(page).to have_current_path(new_user_session_path)
end

Given('I have authentication cookie that has expired') do
  # set default session_timeout
  Rails.configuration.x.session_timeout = 15

  travel_to(20.minutes.ago) do
    login_user
  end

  cookie = get_me_the_cookie('_caz_fleets_session')
  expect(cookie).to_not be_nil
  expect(cookie[:expires] < Time.current).to be true
end

Given('I am signed in') do
  login_user
end

When('I request to sign out') do
  click_link 'Sign Out'
end

When('I enter invalid email format') do
  fill_in('user_email', with: 'user.example.com')
  fill_in('user_password', with: '12345678')

  click_button 'Continue'
end

Then('I change my IP') do
  allow_any_instance_of(ActionDispatch::Request)
    .to receive(:remote_ip)
    .and_return('4.3.2.1')
end
