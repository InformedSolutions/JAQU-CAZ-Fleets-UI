# frozen_string_literal: true

When('I visit the make payment page') do
  mock_debits
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

When('I select any date for vrn on the payment matrix') do
  page.find('.govuk-checkboxes__input', match: :first).click
end

Then('I should be on the confirm payment page') do
  expect_path(review_payments_path)
end

And('I should see the payment details') do
  expect(page).to have_content('Confirm your payment')
end

When('I click view details link') do
  click_link('View details')
end

Then('I should be on the Charge details page') do
  expect_path(review_details_payments_path)
end

And('I want to confirm my payment') do
  mock_debits
  mock_requests_to_payments_api_with(return_url: result_payments_path)
end

Then('I should be on the success payment page') do
  expect_path(success_payments_path)
end

And('I should see success message') do
  expect(page).to have_content('Payment complete')
end

When('I click Next 7 days tab') do
  click_link('Next 7 days')
end

Then('I should be on the Post Payment Details page') do
  expect_path(post_payment_details_payments_path)
end

Then('I should be on the Select payment method page') do
  expect_path(select_payment_method_payments_path)
end
