# frozen_string_literal: true

When('I visit the make payment page') do
  login_user
  visit payments_path
end

Then('I should be on the first upload page') do
  expect(page).to have_current_path(first_upload_fleets_path)
end

Then('I should be on the make a payment page') do
  expect(page).to have_current_path(payments_path)
end
