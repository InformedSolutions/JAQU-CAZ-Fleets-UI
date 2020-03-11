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

And('I want to request payments api') do
  stub_request(:post, /payments/).to_return(
    status: 200,
    body: { 'paymentId' => SecureRandom.uuid, 'nextUrl' => '/' }.to_json
  )
end

Then('I should be on the initiate payment page') do
  expect_path('/')
end

When('I click Next 7 days tab') do
  click_link('Next 7 days')
end
