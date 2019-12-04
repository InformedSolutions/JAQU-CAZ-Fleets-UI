# frozen_string_literal: true

Then("I am taken to the 'Sign In' page") do
  expect(page.current_url).to eq(new_users_session_path)
end

When('I enter valid email address') do
  fill_in('passwords[email_address]', with: 'example@email.com')
  click_button 'Send email'
end

When('I enter invalid email address') do
  fill_in('passwords[email_address]', with: '')
  click_button 'Send email'
end
