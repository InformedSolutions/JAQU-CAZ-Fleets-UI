# frozen_string_literal: true

# content expectations

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should not see {string}') do |string|
  expect(page).not_to have_content(string)
end

# links interactions

Then('I press {string} link') do |string|
  click_link string
end

Then('I press the Continue') do
  click_on 'Continue'
end

Then('I press the Confirm') do
  click_button 'Confirm'
end

Then('I press the Back link') do
  click_link('Back')
end

Then('I should see {string} link') do |string|
  expect(page).to have_link(string)
end

Then('I should not see {string} link') do |string|
  expect(page).not_to have_link(string)
end

Given('I am on the root page') do
  visit '/'
end

When('I am on Dashboard page') do
  login_user
end

Then('I choose {string}') do |string|
  choose(string)
end
