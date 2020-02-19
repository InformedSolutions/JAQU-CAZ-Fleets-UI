# frozen_string_literal: true

When('I visit the make payment page') do
  login_user
  visit payments_path
end

Then('I should be on the first upload page') do
  expect_path(first_upload_fleets_path)
end

Then('I should be on the make a payment page') do
  expect_path(payments_path)
end

Then('I should be on the payment matrix page') do
  expect_path(matrix_payments_path)
end
