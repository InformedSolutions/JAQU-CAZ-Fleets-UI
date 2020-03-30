# frozen_string_literal: true

# content expectations

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see {string} {int} times') do |string, count|
  expect(page).to have_content(string, count: count.to_i)
end

Then('I should not see {string}') do |string|
  expect(page).not_to have_content(string)
end

Then('I select {string}') do |string|
  choose(string)
end

# links interactions

Then('I press {string} link') do |string|
  first(:link, string).click
end

Then('I press the Continue') do
  click_on 'Continue'
end

Then('I press the Confirm') do
  click_button 'Confirm'
end

Then('I press {string} button') do |string|
  click_button string
end

Then('I press the Back link') do
  click_link('Back')
end

Then('I should see {string} link') do |string|
  expect(page).to have_selector(:link_or_button, string)
end

Then('I should not see {string} link') do |string|
  expect(page).not_to have_selector(:link_or_button, string)
end

Then('I choose {string}') do |string|
  choose(string)
end

Then('I should see the Service Unavailable page') do
  expect(page).to have_title 'Sorry, the service is unavailable'
end

When('I reload the page') do
  visit page.current_path
end
